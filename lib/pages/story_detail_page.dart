import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyapp_dicoding/providers/story_provider.dart';
import 'package:storyapp_dicoding/widgets/language_switcher_widget.dart';

class StoryDetailPage extends StatefulWidget {
  final String storyId;
  const StoryDetailPage({super.key, required this.storyId});

  @override
  State<StoryDetailPage> createState() => _StoryDetailPageState();
}

class _StoryDetailPageState extends State<StoryDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<StoryProvider>(context, listen: false)
            .fetchStoryDetail(widget.storyId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('detail_title')),
        actions: const [LanguageSwitcherWidget()],
      ),
      body: Consumer<StoryProvider>(
        builder: (context, provider, child) {
          final state = provider.state;
          if (state == ResultState.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state == ResultState.hasData) {
            final story = provider.story;
            if (story == null) {
              return const Center(child: Text("Story not found."));
            }
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    story.photoUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Center(
                      child: Icon(Icons.error, color: Colors.red),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          story.name,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${tr('posted_on')}: ${story.createdAt.toLocal().toString().substring(0, 16)}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          story.description,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
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
