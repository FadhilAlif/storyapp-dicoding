import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:storyapp_dicoding/providers/auth_provider.dart';
import 'package:storyapp_dicoding/providers/story_provider.dart';
import 'package:storyapp_dicoding/widgets/language_switcher_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('home_title')),
        actions: [
          const LanguageSwitcherWidget(),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthProvider>().logout();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/add-story');
        },
        child: const Icon(Icons.add),
      ),
      body: Consumer<StoryProvider>(
        builder: (context, provider, child) {
          final state = provider.state;
          if (state == ResultState.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state == ResultState.hasData) {
            return RefreshIndicator(
              onRefresh: provider.refreshStories,
              child: ListView.builder(
                itemCount: provider.stories.length,
                itemBuilder: (context, index) {
                  final story = provider.stories[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        context.go('/story/${story.id}');
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            story.photoUrl,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const SizedBox(
                                  height: 200,
                                  child: Center(
                                    child: Icon(Icons.error, color: Colors.red),
                                  ),
                                ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              story.name,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          } else if (state == ResultState.noData) {
            return Center(child: Text(provider.message));
          } else if (state == ResultState.error) {
            return Center(child: Text(provider.message));
          } else {
            return const Center(child: Text(""));
          }
        },
      ),
    );
  }
}
