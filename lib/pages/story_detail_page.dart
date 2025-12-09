import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  GoogleMapController? _mapController;
  String? _address;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StoryProvider>(
        context,
        listen: false,
      ).fetchStoryDetail(widget.storyId);
    });
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _getAddressFromLatLng(double lat, double lon) async {
    try {
      final placemarks = await geo.placemarkFromCoordinates(lat, lon);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        setState(() {
          _address =
              '${place.street}, ${place.subLocality}, ${place.locality}, ${place.country}';
        });
      }
    } catch (e) {
      setState(() {
        _address = tr('address_not_found');
      });
    }
  }

  void _showAddressDialog(String address) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(tr('location_info')),
        content: Text(address),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(tr('close_button')),
          ),
        ],
      ),
    );
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

            final hasLocation = story.lat != null && story.lon != null;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: 'story-image-${story.id}',
                    child: Image.network(
                      story.photoUrl,
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const SizedBox(
                            height: 250,
                            child: Center(
                              child: Icon(Icons.error, color: Colors.red),
                            ),
                          ),
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
                        if (hasLocation) ...[
                          const SizedBox(height: 24),
                          Text(
                            tr('location_label'),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: SizedBox(
                              height: 200,
                              child: GoogleMap(
                                gestureRecognizers: {
                                  Factory<OneSequenceGestureRecognizer>(
                                    () => EagerGestureRecognizer(),
                                  ),
                                },
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(story.lat!, story.lon!),
                                  zoom: 15,
                                ),
                                markers: {
                                  Marker(
                                    markerId: const MarkerId('story_location'),
                                    position: LatLng(story.lat!, story.lon!),
                                    onTap: () async {
                                      if (_address == null) {
                                        await _getAddressFromLatLng(
                                          story.lat!,
                                          story.lon!,
                                        );
                                      }
                                      if (_address != null && mounted) {
                                        _showAddressDialog(_address!);
                                      }
                                    },
                                  ),
                                },
                                onMapCreated: (controller) {
                                  _mapController = controller;
                                  _getAddressFromLatLng(story.lat!, story.lon!);
                                },
                                zoomControlsEnabled: false,
                                mapToolbarEnabled: false,
                              ),
                            ),
                          ),
                          if (_address != null) ...[
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    _address!,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ],
                    ),
                  ),
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
                    onPressed: () => provider.fetchStoryDetail(widget.storyId),
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
