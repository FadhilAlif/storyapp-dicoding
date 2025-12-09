import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:storyapp_dicoding/providers/auth_provider.dart';
import 'package:storyapp_dicoding/providers/story_provider.dart';
import 'package:storyapp_dicoding/widgets/language_switcher_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<StoryProvider>().loadMoreStories();
    }
  }

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
          context.push('/add-story');
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
                controller: _scrollController,
                itemCount: provider.stories.length + (provider.hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == provider.stories.length) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
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
                    child: InkWell(
                      onTap: () {
                        context.push('/story/${story.id}');
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Hero(
                            tag: 'story-image-${story.id}',
                            child: Image.network(
                              story.photoUrl,
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const SizedBox(
                                    height: 200,
                                    child: Center(
                                      child:
                                          Icon(Icons.error, color: Colors.red),
                                    ),
                                  ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    story.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                if (story.lat != null && story.lon != null)
                                  const Icon(
                                    Icons.location_on,
                                    size: 18,
                                    color: Colors.grey,
                                  ),
                              ],
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
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.inbox, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(provider.message),
                ],
              ),
            );
          } else if (state == ResultState.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(provider.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: provider.refreshStories,
                    child: Text(tr('retry_button')),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text(""));
          }
        },
      ),
    );
  }
}
