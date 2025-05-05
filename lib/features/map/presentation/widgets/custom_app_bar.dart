import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuel_finder/features/user/presentation/bloc/user_bloc.dart';
import 'package:fuel_finder/features/user/presentation/bloc/user_event.dart';
import 'package:fuel_finder/features/user/presentation/bloc/user_state.dart';
import 'package:fuel_finder/shared/show_snackbar.dart';
import 'package:fuel_finder/core/themes/app_palette.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? userId;
  final bool showUserInfo;
  final String? title;
  final List<Widget>? actions;
  final bool? centerTitle;

  const CustomAppBar({
    super.key,
    this.userId,
    this.showUserInfo = false,
    this.title,
    this.actions,
    this.centerTitle,
  });

  @override
  Widget build(BuildContext context) {
    if (showUserInfo && userId != null) {
      context.read<UserBloc>().add(GetUserByIdEvent(userId: userId!));
    }

    return AppBar(
      centerTitle: centerTitle,
      automaticallyImplyLeading: false,
      backgroundColor: AppPallete.primaryColor,
      title:
          showUserInfo && userId != null
              ? BlocConsumer<UserBloc, UserState>(
                listener: (context, state) {
                  if (state is UserFailure) {
                    ShowSnackbar.show(context, state.error, isError: true);
                  }
                },
                builder: (context, state) {
                  if (state is UserSuccess) {
                    final user = state.responseData;
                    return Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                            user["data"]["profile_pic"] ??
                                'https://avatar.iran.liara.run/public/boy?username=user',
                          ),
                          radius: 20,
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Hey There",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "${user["data"]["first_name"]} ${user["data"]["last_name"]}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  } else {
                    return const Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                            'https://avatar.iran.liara.run/public/boy?username=user',
                          ),
                          radius: 20,
                        ),
                        SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hey There",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "Loading...",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                },
              )
              : Text(
                title ?? "Title",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

