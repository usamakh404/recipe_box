import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../app/router.dart';
import '../../app/theme/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/widgets/primary_button.dart';
import '../recipes/data/recipe_repository.dart';
import '../recipes/models/recipe.dart';

/// Add Recipe form, split into clearly labeled sections rather than one
/// long field list, per the product spec.
///
/// NOTE ON IMAGES: there's no Firebase Storage upload wired up yet, so
/// this collects an image URL for now. Swapping in a real photo picker +
/// Storage upload is a self-contained follow-up — see the TODO below.
class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _prepController = TextEditingController();
  final _cookController = TextEditingController();
  final _servingsController = TextEditingController(text: '4');
  final _notesController = TextEditingController();

  final List<TextEditingController> _ingredientControllers = [
    TextEditingController(),
  ];
  final List<TextEditingController> _instructionControllers = [
    TextEditingController(),
  ];

  RecipeDifficulty _difficulty = RecipeDifficulty.easy;
  final Set<String> _selectedTags = {};
  bool _isSaving = false;

  static const _availableTags = [
    'Breakfast',
    'Lunch',
    'Dinner',
    'Dessert',
    'Vegetarian',
    'Quick',
    'Easy',
    'High-protein',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    _prepController.dispose();
    _cookController.dispose();
    _servingsController.dispose();
    _notesController.dispose();
    for (final c in _ingredientControllers) {
      c.dispose();
    }
    for (final c in _instructionControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
            vertical: AppSpacing.md,
          ),
          children: [
            Text('Add Recipe', style: Theme.of(context).textTheme.displayLarge),
            const SizedBox(height: 4),
            Text(
              "Fill in the basics — you can always come back and edit later.",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            _SectionCard(
              title: 'Basics',
              children: [
                _LabeledField(
                  label: 'Title',
                  child: TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(hintText: 'e.g. Lemon Herb Roast Chicken'),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Give your recipe a name' : null,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                _LabeledField(
                  label: 'Description',
                  child: TextFormField(
                    controller: _descriptionController,
                    maxLines: 3,
                    decoration: const InputDecoration(hintText: 'A short, tasty description'),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                _LabeledField(
                  label: 'Photo URL',
                  child: TextFormField(
                    controller: _imageUrlController,
                    decoration: const InputDecoration(hintText: 'https://...'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            _SectionCard(
              title: 'Ingredients',
              children: [
                ..._ingredientControllers.asMap().entries.map(
                      (e) => _RemovableField(
                        controller: e.value,
                        hint: 'e.g. 2 cups flour',
                        onRemove: _ingredientControllers.length > 1
                            ? () => setState(() => _ingredientControllers.removeAt(e.key))
                            : null,
                      ),
                    ),
                const SizedBox(height: 4),
                _AddLineButton(
                  label: 'Add ingredient',
                  onTap: () => setState(() => _ingredientControllers.add(TextEditingController())),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            _SectionCard(
              title: 'Instructions',
              children: [
                ..._instructionControllers.asMap().entries.map(
                      (e) => _RemovableField(
                        controller: e.value,
                        hint: 'Step ${e.key + 1}',
                        maxLines: 2,
                        onRemove: _instructionControllers.length > 1
                            ? () => setState(() => _instructionControllers.removeAt(e.key))
                            : null,
                      ),
                    ),
                const SizedBox(height: 4),
                _AddLineButton(
                  label: 'Add step',
                  onTap: () => setState(() => _instructionControllers.add(TextEditingController())),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            _SectionCard(
              title: 'Details',
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _LabeledField(
                        label: 'Prep (min)',
                        child: TextFormField(
                          controller: _prepController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(hintText: '15'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _LabeledField(
                        label: 'Cook (min)',
                        child: TextFormField(
                          controller: _cookController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(hintText: '30'),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: _LabeledField(
                        label: 'Servings',
                        child: TextFormField(
                          controller: _servingsController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(hintText: '4'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _LabeledField(
                        label: 'Difficulty',
                        child: DropdownButtonFormField<RecipeDifficulty>(
                          value: _difficulty,
                          decoration: const InputDecoration(),
                          items: RecipeDifficulty.values
                              .map((d) => DropdownMenuItem(value: d, child: Text(d.label)))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) setState(() => _difficulty = value);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Text('Tags', style: Theme.of(context).textTheme.labelMedium),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _availableTags.map((tag) {
                    final selected = _selectedTags.contains(tag);
                    return FilterChip(
                      label: Text(tag),
                      selected: selected,
                      showCheckmark: false,
                      selectedColor: AppColors.primaryGreen,
                      labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: selected ? Colors.white : null,
                          ),
                      onSelected: (v) => setState(() {
                        v ? _selectedTags.add(tag) : _selectedTags.remove(tag);
                      }),
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppSpacing.md),
                _LabeledField(
                  label: 'Notes (optional)',
                  child: TextFormField(
                    controller: _notesController,
                    maxLines: 2,
                    decoration: const InputDecoration(hintText: 'Substitutions, tips, storage...'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            PrimaryButton(
              label: 'Save to your recipe box',
              isLoading: _isSaving,
              onPressed: _handleSave,
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSave() async {
    final ingredients = _ingredientControllers.map((c) => c.text.trim()).where((t) => t.isNotEmpty).toList();
    final instructions = _instructionControllers.map((c) => c.text.trim()).where((t) => t.isNotEmpty).toList();

    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (ingredients.isEmpty || instructions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add at least one ingredient and one step.')),
      );
      return;
    }

    setState(() => _isSaving = true);
    final now = DateTime.now();
    final recipe = Recipe(
      id: '', // assigned by the API (auto-increment id from MySQL)
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      imageUrl: _imageUrlController.text.trim(),
      author: 'You',
      prepTimeMinutes: int.tryParse(_prepController.text) ?? 0,
      cookTimeMinutes: int.tryParse(_cookController.text) ?? 0,
      servings: int.tryParse(_servingsController.text) ?? 1,
      difficulty: _difficulty,
      ingredients: ingredients,
      instructions: instructions,
      notes: _notesController.text.trim(),
      tags: _selectedTags.map((t) => t.toLowerCase()).toList(),
      cuisine: '',
      mealType: _selectedTags.firstWhere(
        (t) => ['Breakfast', 'Lunch', 'Dinner', 'Dessert'].contains(t),
        orElse: () => '',
      ),
      createdAt: now,
      updatedAt: now,
    );

    try {
      await context.read<RecipeRepository>().addRecipe(recipe);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saved to your recipe box')),
      );
      context.go(AppRoutes.myRecipes);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("We couldn't save that recipe. Please try again.")),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}

class _RemovableField extends StatelessWidget {
  const _RemovableField({
    required this.controller,
    required this.hint,
    this.onRemove,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String hint;
  final VoidCallback? onRemove;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              maxLines: maxLines,
              decoration: InputDecoration(hintText: hint),
            ),
          ),
          if (onRemove != null)
            IconButton(
              onPressed: onRemove,
              icon: const Icon(Icons.close_rounded, color: AppColors.mutedText, size: 20),
            ),
        ],
      ),
    );
  }
}

class _AddLineButton extends StatelessWidget {
  const _AddLineButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onTap,
      icon: const Icon(Icons.add_rounded, size: 18),
      label: Text(label),
      style: TextButton.styleFrom(
        foregroundColor: AppColors.goldenAccent,
        padding: EdgeInsets.zero,
        alignment: Alignment.centerLeft,
      ),
    );
  }
}
