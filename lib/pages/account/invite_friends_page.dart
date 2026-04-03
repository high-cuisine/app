import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/referal_bloc/referal_bloc.dart';
import '../../widgets/custom_arrowback.dart';

class InviteFriendsPage extends StatefulWidget {
  const InviteFriendsPage({super.key});

  @override
  State<InviteFriendsPage> createState() => _InviteFriendsPageState();
}

class _InviteFriendsPageState extends State<InviteFriendsPage> {
  @override
  void initState() {
    super.initState();
    context.read<ReferralBloc>().add(FetchReferralCode());
  }

  void _copyToClipboard(String referralCode) {
    Clipboard.setData(ClipboardData(text: referralCode));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Реферальный код $referralCode скопирован!"),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 15, left: 14, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBar(
                text: tr('account_page.invite_friends'),
                arrow: true,
                auth: false,
                onPressed: null,
              ),
              const SizedBox(height: 70),
              BlocBuilder<ReferralBloc, ReferralState>(
                builder: (context, state) {
                  if (state is ReferralCodeLoaded) {
                    return GestureDetector(
                      onTap: () => _copyToClipboard(state.referralCode),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue, width: 2),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.blue.withOpacity(0.1),
                        ),
                        child: Center(
                          child: Text(
                            state.referralCode,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                    );
                  } else if (state is ReferralError) {
                    return Text(
                      "Ошибка: ${state.message}",
                      style: const TextStyle(color: Colors.red),
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
