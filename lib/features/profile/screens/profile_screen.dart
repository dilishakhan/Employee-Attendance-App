import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/profile_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  bool initialized = false;
  bool isUpdating = false;

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("My Profile")),

      body: profile.when(
        loading: () => const Center(child: CircularProgressIndicator()),

        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(e.toString()),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(profileProvider);
                },
                child: const Text("Retry"),
              ),
            ],
          ),
        ),

        data: (user) {
          if (!initialized) {
            nameController.text = user.name;
            phoneController.text = user.phone;
            initialized = true;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),

            child: Form(
              key: _formKey,

              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 45,
                    child: Icon(Icons.person, size: 45),
                  ),

                  const SizedBox(height: 25),

                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "Name",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Enter your name";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: "Phone Number",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Enter phone number";
                      }

                      if (value.length != 10) {
                        return "Phone number must be 10 digits";
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  TextFormField(
                    initialValue: user.department,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: "Department",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextFormField(
                    initialValue: user.role,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: "Role",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isUpdating
                          ? null
                          : () async {
                              if (!_formKey.currentState!.validate()) {
                                return;
                              }

                              setState(() {
                                isUpdating = true;
                              });

                              try {
                                await ref
                                    .read(profileServiceProvider)
                                    .updateProfile(
                                      name: nameController.text.trim(),
                                      phone: phoneController.text.trim(),
                                    );

                                ref.invalidate(profileProvider);

                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Profile updated successfully",
                                      ),
                                    ),
                                  );
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(e.toString())),
                                  );
                                }
                              } finally {
                                if (mounted) {
                                  setState(() {
                                    isUpdating = false;
                                  });
                                }
                              }
                            },
                      child: isUpdating
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text("Update Profile"),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
