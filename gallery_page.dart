import 'package:flutter/material.dart';
import '../services/gallery_service.dart';
import '../models/gallery_model.dart';

class GalleryPage extends StatefulWidget {
  final VoidCallback onPrevious;
  final String username;

  const GalleryPage({
    Key? key,
    required this.onPrevious,
    required this.username,
  }) : super(key: key);

  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  final GalleryService _galleryService = GalleryService();
  late List<GalleryItem> _photos;
  late List<GalleryItem> _videos;

  @override
  void initState() {
    super.initState();
    _loadGalleryData();
  }

  void _loadGalleryData() {
    _photos = _galleryService.getImages();
    _videos = _galleryService.getVideos();

    if (_photos.isEmpty) {
      _photos = List.generate(
          6,
          (index) => GalleryItem(
                id: 'photo_$index',
                type: 'image',
                url: 'https://picsum.photos/400/600?random=$index',
                thumbnail: 'https://picsum.photos/200/300?random=$index',
                title: 'Birthday Memory ${index + 1}',
                uploadedAt: DateTime.now().subtract(Duration(days: index)),
              ));
    }

    if (_videos.isEmpty) {
      _videos = List.generate(
          3,
          (index) => GalleryItem(
                id: 'video_$index',
                type: 'video',
                url: 'video_$index',
                thumbnail:
                    'https://picsum.photos/300/200?random=${index + 100}',
                title: 'Birthday Video ${index + 1}',
                uploadedAt: DateTime.now().subtract(Duration(days: index)),
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.purple,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: widget.onPrevious,
          ),
          title: Text(
            'Birthday Memories',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: TabBar(
            indicatorColor: Colors.yellow,
            labelColor: Colors.yellow,
            unselectedLabelColor: Colors.white70,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            tabs: [
              Tab(
                icon: Icon(Icons.photo),
                text: 'PHOTOS (${_photos.length})',
              ),
              Tab(
                icon: Icon(Icons.video_library),
                text: 'VIDEOS (${_videos.length})',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildPhotosGrid(),
            _buildVideosList(),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotosGrid() {
    return _photos.isEmpty
        ? _buildEmptyState(Icons.photo_library, 'No photos yet')
        : GridView.builder(
            padding: EdgeInsets.all(12),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            itemCount: _photos.length,
            itemBuilder: (context, index) {
              final photo = _photos[index];
              return Hero(
                tag: 'photo_${photo.id}',
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      children: [
                        Image.network(
                          photo.thumbnail,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[200],
                              child: Icon(Icons.error, color: Colors.grey),
                            );
                          },
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.black.withOpacity(0.7),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                            child: Text(
                              photo.title,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
  }

  Widget _buildVideosList() {
    return _videos.isEmpty
        ? _buildEmptyState(Icons.video_library, 'No videos yet')
        : ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: _videos.length,
            itemBuilder: (context, index) {
              final video = _videos[index];
              return Card(
                elevation: 4,
                margin: EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      child: Stack(
                        children: [
                          Image.network(
                            video.thumbnail,
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                height: 200,
                                child:
                                    Center(child: CircularProgressIndicator()),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 200,
                                color: Colors.grey[200],
                                child: Icon(Icons.error,
                                    color: Colors.grey, size: 50),
                              );
                            },
                          ),
                          Positioned.fill(
                            child: Center(
                              child: Container(
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.video_library, color: Colors.purple),
                      title: Text(
                        video.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text('Click to play birthday video'),
                      trailing: Icon(Icons.more_vert, color: Colors.grey),
                      onTap: () {
                        _showVideoDialog(video.title);
                      },
                    ),
                  ],
                ),
              );
            },
          );
  }

  Widget _buildEmptyState(IconData icon, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          SizedBox(height: 8),
          Text(
            'Check back later for birthday memories!',
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showVideoDialog(String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.purple[50],
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.play_circle_filled,
                  size: 60, color: Colors.purple),
            ),
            SizedBox(height: 16),
            Text(
              'Video playback would start here!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
            child: Text('Play Video'),
          ),
        ],
      ),
    );
  }
}
