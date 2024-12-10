import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/utils/show_snack_bar.dart';
import '../../domain/dtos/get_pets_params.dart';
import '../viewmodels/home_viewmodel.dart';

class FiltersPage extends StatefulWidget {
  const FiltersPage({super.key});

  @override
  State<FiltersPage> createState() => _FiltersPageState();
}

class _FiltersPageState extends State<FiltersPage> {
  final homeViewModel = GetIt.I.get<HomeViewmodel>();
  final petsParams = GetPetsParams.empty();

  @override
  void initState() {
    super.initState();
    homeViewModel.getPet.addListener(listener);
  }

  listener() {
    if (homeViewModel.getPet.completed) {
      final exception = homeViewModel.getPet.result?.getOrNull();
      if (exception != null) {
        showMessageSnackBar(
          context,
          exception.message,
          icon: Icons.error,
          iconColor: AppColors.whiteColor,
          color: AppColors.primaryColor,
        );
      }
    }
  }

  @override
  void dispose() {
    homeViewModel.getPet.removeListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Bem-vindo(a),',
                          style: theme.textTheme.headlineSmall,
                        ),
                        TextSpan(
                          text: 'Mariana!',
                          style: theme.textTheme.headlineMedium,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Encontre o seu amigo peludo.',
                    style: theme.textTheme.labelSmall!.copyWith(fontSize: 16),
                  ),
                  const Gap(24),
                  ChoosePetTypeRow(
                    onChanged: petsParams.setType,
                    label: 'Qual pet você gostaria de doar?',
                  ),
                  const Gap(24),
                  ChoosePetGenderRow(
                    onChanged: petsParams.setGender,
                    label: 'Qual o sexo?',
                  ),
                  const Gap(24),
                  ChoosePetDonationTypeRow(
                    onChanged: (petDonationType) {},
                    label: 'Qual o tipo da doação?',
                  ),
                  const Gap(24),
                  ChoosePetSizeRow(
                    onChanged: (petSize) {},
                    label: 'E o tamanho?',
                  ),
                  const Gap(24),
                  const AgeSlider(),
                  const Gap(48),
                  ListenableBuilder(
                      listenable: homeViewModel,
                      builder: (context, _) {
                        return ListView.builder(
                          itemCount: homeViewModel.pets.length,
                          itemBuilder: (context, index) {
                            return const SizedBox();
                          },
                        );
                      }),
                  ListenableBuilder(
                      listenable: homeViewModel.getPet,
                      builder: (context, _) {
                        if (homeViewModel.getPet.running) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return PrimaryButtonDs(
                            width: double.maxFinite,
                            title: 'Adote o seu pet',
                            onPressed: () {
                              homeViewModel.getPet.execute(petsParams);
                            });
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
