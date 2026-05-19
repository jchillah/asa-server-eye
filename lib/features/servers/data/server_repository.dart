// features/servers/data/server_repository.dart
import 'dart:async';

import 'package:dio/dio.dart';

import '../../../core/utils/app_logger.dart';
import '../domain/server.dart';
import 'cached_servers_result.dart';
import 'server_cache_repository.dart';

enum ServerRepositoryExceptionType { network, timeout, invalidFormat, unknown }

class ServerRepositoryException implements Exception {
  const ServerRepositoryException._({
    required this.type,
    required this.originalError,
  });

  final ServerRepositoryExceptionType type;
  final Object originalError;

  factory ServerRepositoryException.network(Object error) {
    return ServerRepositoryException._(
      type: ServerRepositoryExceptionType.network,
      originalError: error,
    );
  }

  factory ServerRepositoryException.timeout(Object error) {
    return ServerRepositoryException._(
      type: ServerRepositoryExceptionType.timeout,
      originalError: error,
    );
  }

  factory ServerRepositoryException.invalidFormat(Object error) {
    return ServerRepositoryException._(
      type: ServerRepositoryExceptionType.invalidFormat,
      originalError: error,
    );
  }

  factory ServerRepositoryException.unknown(Object error) {
    return ServerRepositoryException._(
      type: ServerRepositoryExceptionType.unknown,
      originalError: error,
    );
  }

  @override
  String toString() {
    return 'ServerRepositoryException(type: $type, originalError: $originalError)';
  }
}

class ServerRepository {
  ServerRepository(this._dio, this._cacheRepository);

  final Dio _dio;
  final ServerCacheRepository _cacheRepository;

  static const _url =
      'https://cdn2.arkdedicated.com/servers/asa/officialserverlist.json';

  static bool _isTimeoutException(DioException error) {
    return error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout;
  }

  Future<CachedServersResult> fetchServers() async {
    try {
      final servers = await _fetchServersFromNetwork();
      await _cacheRepository.saveServers(servers);

      AppLogger.info('ServerRepository', 'Loaded servers from network.');
      AppLogger.info('ServerRepository', 'Saved servers to cache.');

      final lastUpdatedAt = await _cacheRepository.getLastUpdatedAt();

      return CachedServersResult(
        servers: servers,
        lastUpdatedAt: lastUpdatedAt,
        isFromCache: false,
      );
    } on ServerRepositoryException catch (error) {
      if (error.type != ServerRepositoryExceptionType.network &&
          error.type != ServerRepositoryExceptionType.timeout) {
        rethrow;
      }

      return _loadFromCacheOrThrow(error);
    }
  }

  Future<CachedServersResult> _loadFromCacheOrThrow(
    ServerRepositoryException originalError,
  ) async {
    final cachedServers = await _cacheRepository.getCachedServers();

    if (cachedServers == null || cachedServers.isEmpty) {
      AppLogger.warning(
        'ServerRepository',
        'No cached servers available.',
      );
      throw originalError;
    }

    final lastUpdatedAt = await _cacheRepository.getLastUpdatedAt();

    AppLogger.info(
      'ServerRepository',
      'Loaded servers from cache fallback.',
    );

    return CachedServersResult(
      servers: cachedServers,
      lastUpdatedAt: lastUpdatedAt,
      isFromCache: true,
    );
  }

  Future<List<Server>> _fetchServersFromNetwork() async {
    try {
      final response = await _dio.get<List<dynamic>>(_url);
      final Object? rawData = response.data;

      if (rawData == null) {
        throw const FormatException('Server response data was null.');
      }

      if (rawData is! List) {
        throw const FormatException('Invalid server response format.');
      }

      final servers = <Server>[];

      for (final item in rawData) {
        if (item is! Map<String, dynamic>) {
          AppLogger.warning(
            'ServerRepository',
            'Skipped invalid server item because it is not a JSON object.',
          );
          continue;
        }

        final server = Server.fromJson(item);

        if (server.id.isEmpty) {
          AppLogger.warning(
            'ServerRepository',
            'Skipped server because no stable id could be resolved.',
          );
          continue;
        }

        servers.add(server);
      }

      AppLogger.info(
        'ServerRepository',
        'Loaded ${servers.length} servers successfully.',
      );

      return servers;
    } on DioException catch (error, stackTrace) {
      AppLogger.error(
        'ServerRepository',
        'Failed to fetch servers.',
        error: error,
        stackTrace: stackTrace,
      );

      if (_isTimeoutException(error)) {
        throw ServerRepositoryException.timeout(error);
      }

      throw ServerRepositoryException.network(error);
    } on TimeoutException catch (error, stackTrace) {
      AppLogger.error(
        'ServerRepository',
        'Failed to fetch servers.',
        error: error,
        stackTrace: stackTrace,
      );
      throw ServerRepositoryException.timeout(error);
    } on FormatException catch (error, stackTrace) {
      AppLogger.error(
        'ServerRepository',
        'Failed to fetch servers.',
        error: error,
        stackTrace: stackTrace,
      );
      throw ServerRepositoryException.invalidFormat(error);
    } catch (error, stackTrace) {
      AppLogger.error(
        'ServerRepository',
        'Failed to fetch servers.',
        error: error,
        stackTrace: stackTrace,
      );
      throw ServerRepositoryException.unknown(error);
    }
  }
}
