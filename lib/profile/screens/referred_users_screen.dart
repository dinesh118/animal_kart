import 'package:animal_kart_demo2/profile/models/reffer_user_model.dart';
import 'package:animal_kart_demo2/profile/models/refferal_user_state.dart';
import 'package:animal_kart_demo2/profile/providers/refferal_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReferralUsersScreen extends ConsumerStatefulWidget {
  final String mobile;

  const ReferralUsersScreen({
    super.key,
    required this.mobile,
  });

  @override
  ConsumerState<ReferralUsersScreen> createState() => _ReferralUsersScreenState();
}

class _ReferralUsersScreenState extends ConsumerState<ReferralUsersScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch immediately after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(refferalUserProvider.notifier).fetchUsersByMobile(widget.mobile);
    });
  }

  // Optional: Refresh when pulling down
  Future<void> _refresh() async {
    await ref.read(refferalUserProvider.notifier).fetchUsersByMobile(widget.mobile);
  }

  void _onUserTap(RefUsers user) {
    debugPrint('user clicked');
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (_) => UserDetailsScreen(user: user)),
    // );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(refferalUserProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Referred Users')),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: _buildBody(state),
      ),
    );
  }

  Widget _buildBody(RefferalUserState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                state.error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref
                    .read(refferalUserProvider.notifier)
                    .fetchUsersByMobile(widget.mobile),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (state.userResponse == null || state.userResponse!.refferalUsers.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No referred users found',
              style: TextStyle(color: Colors.grey, fontSize: 18),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.userResponse!.refferalUsers.length,
      itemBuilder: (context, index) {
        final user = state.userResponse!.refferalUsers[index];

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => _onUserTap(user),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.fullName.isEmpty ? 'Unknown User' : user.fullName,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.phone, size: 16, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(
                          user.mobile,
                          style: const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}