import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:partner/models/mModel/modelCategory.dart';
import 'package:partner/models/mModel/modelItemCategory.dart';
import 'package:partner/models/mModel/modelItemSubCategory.dart';
import 'package:partner/provider/providers.dart';
import 'package:partner/shared/custom_widgets.dart';

class CategorySelectionPage extends ConsumerStatefulWidget {
  const CategorySelectionPage({Key? key}) : super(key: key);

  @override
  ConsumerState<CategorySelectionPage> createState() => _CategorySelectionPageState();
}

class _CategorySelectionPageState extends ConsumerState<CategorySelectionPage> {
  @override
  Widget build(BuildContext context) {
    final categoryState = ref.watch(categoryListProvider);
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: categoryState.when(
                data: (List<NMCategory> categories) {
                  return ListView.builder(
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        return ExpansionTile(
                          title: Text(
                            categories[index].name ?? '',
                          ),
                          children:
                              ref.watch(subCategoryListProvider(categories[index].categoryID ?? '')).when(
                                  data: (List<SubCategory> subCategories) {
                                    return subCategories.map((e) {
                                      return ExpansionTile(
                                        title: Text(e.subCategoryName ?? ''),
                                        children: ref
                                            .watch(multiBrandListProvider(
                                                subCategories[index].subCategoryId ?? ''))
                                            .when(
                                                data: (List<Brand> brands) {
                                                  return brands
                                                      .map((Brand e) => ListTile(
                                                            title: Text(subCategories[index].subCategoryName ?? '' + e.name),
                                                          ))
                                                      .toList();
                                                },
                                                error: (_, __) => [
                                                      AppErrorWidget(
                                                        onPressed: () =>
                                                            ref.refresh(categoryListProvider),
                                                      )
                                                    ],
                                                loading: () => [CupertinoActivityIndicator()]),
                                      );
                                    }).toList();
                                  },
                                  error: (_, __) => [
                                        AppErrorWidget(
                                          onPressed: () => ref.refresh(categoryListProvider),
                                        )
                                      ],
                                  loading: () => [CupertinoActivityIndicator()]),
                        );
                      });
                },
                error: (_, __) => AppErrorWidget(
                      onPressed: () => ref.refresh(categoryListProvider),
                    ),
                loading: () => CupertinoActivityIndicator()),
          ),
        ],
      ),
    );
  }
}
