// features/profile/presentation/controllers/profile_form_controller.dart
import 'dart:io';

import 'package:asa_server_eye/features/profile/presentation/models/profile_delete_result.dart';
import 'package:asa_server_eye/features/profile/presentation/models/profile_save_result.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/profile_repository.dart';
import '../../domain/app_user_profile.dart';

class ProfileFormController extends ChangeNotifier {
  ProfileFormController(this._profileRepository);

  final ProfileRepository _profileRepository;

  final TextEditingController usernameController = TextEditingController();

  File? _selectedImageFile;
  String? _hydratedProfileId;
  bool _isSaving = false;
  bool _isDeleting = false;

  File? get selectedImageFile => _selectedImageFile;
  bool get isSaving => _isSaving;
  bool get isDeleting => _isDeleting;

  void hydrate(AppUserProfile profile) {
    if (_hydratedProfileId == profile.id) return;

    usernameController.text = profile.username;
    _hydratedProfileId = profile.id;
  }

  ImageProvider<Object>? resolveAvatarImage(String? profilePhotoUrl) {
    if (_selectedImageFile != null) {
      return FileImage(_selectedImageFile!);
    }

    if (profilePhotoUrl != null && profilePhotoUrl.isNotEmpty) {
      return NetworkImage(profilePhotoUrl);
    }

    return null;
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();

    final pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedImage == null) return;

    _selectedImageFile = File(pickedImage.path);
    notifyListeners();
  }

  Future<ProfileSaveResult> saveProfile({
    required AppUserProfile currentProfile,
  }) async {
    final trimmedUsername = usernameController.text.trim();

    if (trimmedUsername.isEmpty) {
      return ProfileSaveResult.usernameEmpty;
    }

    if (trimmedUsername.length < 3) {
      return ProfileSaveResult.usernameTooShort;
    }

    if (trimmedUsername.length > 20) {
      return ProfileSaveResult.usernameTooLong;
    }

    final usernameRegex = RegExp(r'^[a-zA-Z0-9._-]+$');
    if (!usernameRegex.hasMatch(trimmedUsername)) {
      return ProfileSaveResult.usernameInvalidCharacters;
    }

    _setSaving(true);

    try {
      String? uploadedPhotoUrl;

      if (_selectedImageFile != null) {
        uploadedPhotoUrl = await _profileRepository.uploadProfileImage(
          _selectedImageFile!,
        );
      }

      await _profileRepository.updateProfile(
        currentProfile: currentProfile,
        username: trimmedUsername,
        newPhotoUrl: uploadedPhotoUrl,
      );

      _selectedImageFile = null;
      notifyListeners();

      return ProfileSaveResult.success;
    } catch (_) {
      return ProfileSaveResult.failure;
    } finally {
      _setSaving(false);
    }
  }

  Future<ProfileDeleteResult> deleteAccount({
    required String email,
    required String password,
  }) async {
    if (password.trim().isEmpty) {
      return ProfileDeleteResult.cancelled;
    }

    _setDeleting(true);

    try {
      await _profileRepository.deleteAccount(email: email, password: password);

      return ProfileDeleteResult.success;
    } catch (_) {
      return ProfileDeleteResult.failure;
    } finally {
      _setDeleting(false);
    }
  }

  void _setSaving(bool value) {
    if (_isSaving == value) return;
    _isSaving = value;
    notifyListeners();
  }

  void _setDeleting(bool value) {
    if (_isDeleting == value) return;
    _isDeleting = value;
    notifyListeners();
  }

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }
}
