// features/servers/presentation/screens/server_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_l10n.dart';
import '../../../../core/widgets/ad_banner_widget.dart';
import '../controllers/server_search_controller.dart';
import '../providers/server_view_providers.dart';
import '../utils/server_navigation.dart';
import '../utils/server_refresh_action.dart';
import '../widgets/server_list_item.dart';
import '../widgets/server_search_section.dart';

class ServerListScreen extends ConsumerWidget {
  const ServerListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = ref.watch(serverSearchControllerProvider);
    final filteredServersAsync = ref.watch(filteredServersProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.servers)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: ServerSearchSection(
              title: context.l10n.servers,
              subtitle: context.l10n.searchServersOrMaps,
              hintText: context.l10n.searchServersOrMaps,
              controller: searchController.textController,
              query: searchController.query,
              onChanged: searchController.updateQuery,
              onClear: searchController.clear,
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => ServerRefreshAction.run(ref),
              child: filteredServersAsync.when(
                data: (servers) {
                  if (servers.isEmpty) {
                    return ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        const SizedBox(height: 120),
                        Center(
                          child: Text(
                            searchController.query.isEmpty
                                ? context.l10n.noServersFound
                                : context.l10n.noServersMatchSearch,
                            style: theme.textTheme.bodyLarge,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    itemCount: servers.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final server = servers[index];

                      return ServerListItem(
                        server: server,
                        officialLabel: context.l10n.official,
                        unofficialLabel: context.l10n.unofficial,
                        onTap: () =>
                            ServerNavigation.openDetails(context, server.id),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) => ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    const SizedBox(height: 120),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          context.l10n.genericError,
                          style: theme.textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Center(child: AdBannerWidget()),
          ),
        ],
      ),
    );
  }
}
