import 'package:auto_route/auto_route.dart';
import 'package:demo_swapi/core/theme/star_wars_theme.dart';
import 'package:flutter/material.dart';
import 'package:demo_swapi/core/theme/app_colors.dart';
import 'package:demo_swapi/domain/entities/person_entity.dart';

@RoutePage()
class PersonDetailPage extends StatelessWidget {
  const PersonDetailPage({super.key, required this.person});

  final PersonEntity person;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Hero(
          tag: 'person_name_${person.name}',
          child: Material(
            color: Colors.transparent,
            child: Text(
              person.name.toUpperCase(),
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: AppColors.forceYellow, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.forceYellow, width: 3),
                    boxShadow: [StarWarsTheme.glowShadow],
                  ),
                  child: Icon(Icons.person, size: 80, color: AppColors.forceYellow),
                ),
              ),
              const SizedBox(height: 32),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _DetailRow(icon: Icons.person, label: 'Name', value: person.name),
                      const SizedBox(height: 16),
                      if (person.gender.isNotEmpty)
                        _DetailRow(
                          icon: person.gender.toLowerCase() == 'male'
                              ? Icons.male
                              : person.gender.toLowerCase() == 'female'
                              ? Icons.female
                              : Icons.person,
                          label: 'Gender',
                          value: person.gender,
                        ),
                      if (person.gender.isNotEmpty) const SizedBox(height: 16),
                      if (person.birthYear.isNotEmpty)
                        _DetailRow(icon: Icons.calendar_today, label: 'Birth Year', value: person.birthYear),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.forceYellow, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondaryText)),
              const SizedBox(height: 6),
              Text(value, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }
}
