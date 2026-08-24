import 'package:flutter/material.dart';

import '../network/api_client.dart';
import '../theme/app_colors.dart';
import '../theme/app_icons.dart';
import '../theme/app_text_style.dart';

class ApiStatusIndicator extends StatefulWidget {
  const ApiStatusIndicator({super.key});

  @override
  State<ApiStatusIndicator> createState() => _ApiStatusIndicatorState();
}

class _ApiStatusIndicatorState extends State<ApiStatusIndicator> {
  final ApiClient _apiClient = ApiClient();
  ApiConnectionState _status = ApiConnectionState.checking;

  @override
  void initState() {
    super.initState();
    _checkConnection();
  }

  Future<void> _checkConnection() async {
    if (mounted) {
      setState(() => _status = ApiConnectionState.checking);
    }

    final status = await _apiClient.checkConnection();
    if (!mounted) return;

    setState(() => _status = status);
  }

  String get _label {
    switch (_status) {
      case ApiConnectionState.checking:
        return 'در حال بررسی';
      case ApiConnectionState.connected:
        return 'API متصل';
      case ApiConnectionState.serverError:
        return 'خطای سرور';
      case ApiConnectionState.disconnected:
        return 'API قطع';
    }
  }

  Color get _color {
    switch (_status) {
      case ApiConnectionState.checking:
        return AppColors.warning;
      case ApiConnectionState.connected:
        return AppColors.success;
      case ApiConnectionState.serverError:
        return AppColors.warning;
      case ApiConnectionState.disconnected:
        return AppColors.danger;
    }
  }

  IconData get _icon {
    switch (_status) {
      case ApiConnectionState.checking:
        return Icons.sync_rounded;
      case ApiConnectionState.connected:
        return AppIcons.success;
      case ApiConnectionState.serverError:
        return AppIcons.warning;
      case ApiConnectionState.disconnected:
        return AppIcons.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'برای بررسی دوباره کلیک کنید',
      child: InkWell(
        onTap: _checkConnection,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(_icon, color: _color, size: 17),
              const SizedBox(width: 6),
              Text(
                _label,
                style: AppTextStyles.bodySmall.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}