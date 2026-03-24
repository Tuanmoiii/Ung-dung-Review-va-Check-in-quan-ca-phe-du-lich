import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:btl_mobile/services/api_service.dart';
import 'package:btl_mobile/screens/checkin/checkin_code_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 4;
  bool _isLoading = true;
  Map<String, dynamic>? _userData;

  // Tab controller
  late TabController _tabController;

  // Data for tabs
  List<dynamic> _userPosts = [];
  List<dynamic> _userReviews = [];
  List<dynamic> _userFavorites = [];

  bool _isLoadingPosts = true;
  bool _isLoadingReviews = true;
  bool _isLoadingFavorites = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadUserData();
    _loadUserPosts();
    _loadUserReviews();
    _loadUserFavorites();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadUserData() {
    final currentUser = ApiService.currentUser;
    if (currentUser != null) {
      setState(() {
        _userData = currentUser;
        _isLoading = false;
      });
    } else {
      Future.microtask(() {
        Navigator.pushReplacementNamed(context, '/login');
      });
    }
  }

  Future<void> _loadUserPosts() async {
    final currentUser = ApiService.currentUser;
    if (currentUser == null) return;

    setState(() => _isLoadingPosts = true);
    try {
      final posts = await ApiService.getPostsByUser(currentUser['id']);
      setState(() {
        _userPosts = posts;
        _isLoadingPosts = false;
      });
    } catch (e) {
      print('Error loading user posts: $e');
      setState(() => _isLoadingPosts = false);
    }
  }

  Future<void> _loadUserReviews() async {
    final currentUser = ApiService.currentUser;
    if (currentUser == null) return;

    print('=== LOADING USER REVIEWS ===');
    print(
      'Current user: ${currentUser['username']} (id: ${currentUser['id']})',
    );

    setState(() => _isLoadingReviews = true);
    try {
      final reviews = await ApiService.getReviewsByUser(currentUser['id']);
      print('Reviews found: ${reviews.length}');
      print('Reviews: $reviews');

      setState(() {
        _userReviews = reviews;
        _isLoadingReviews = false;
      });
    } catch (e) {
      print('Error loading user reviews: $e');
      setState(() => _isLoadingReviews = false);
    }
  }

  Future<void> _loadUserFavorites() async {
    final currentUser = ApiService.currentUser;
    if (currentUser == null) return;

    setState(() => _isLoadingFavorites = true);
    try {
      final favorites = await ApiService.getFavoritesWithUserId(
        currentUser['id'],
      );
      setState(() {
        _userFavorites = favorites;
        _isLoadingFavorites = false;
      });
    } catch (e) {
      print('Error loading user favorites: $e');
      setState(() => _isLoadingFavorites = false);
    }
  }

  String _formatTimeAgo(String? dateTimeStr) {
    if (dateTimeStr == null) return 'Just now';
    try {
      final date = DateTime.parse(dateTimeStr);
      final difference = DateTime.now().difference(date);
      if (difference.inDays > 7) {
        return '${(difference.inDays / 7).floor()} weeks ago';
      } else if (difference.inDays > 0) {
        return '${difference.inDays} days ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} hours ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} minutes ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return 'Recently';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color(0xff2e2f2d)),
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: Color(0xffa03b00),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.wait([
            _loadUserPosts(),
            _loadUserReviews(),
            _loadUserFavorites(),
          ]);
        },
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(child: _buildProfileHeader()),
              SliverToBoxAdapter(child: _buildStatsRow()),
              SliverToBoxAdapter(child: _buildTabBar()),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildPostsTab(),
              _buildReviewsTab(),
              _buildFavoritesTab(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xffa03b00),
              shape: BoxShape.circle,
              image: _userData?['avatar'] != null
                  ? DecorationImage(
                      image: NetworkImage(_userData!['avatar']),
                      fit: BoxFit.cover,
                    )
                  : null,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xffa03b00).withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: _userData?['avatar'] == null
                ? const Icon(Icons.person, color: Colors.white, size: 40)
                : null,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _userData?['username'] ?? 'User',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff2e2f2d),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _userData?['email'] ?? 'email@example.com',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xffa03b00).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.emoji_events,
                        size: 12,
                        color: Color(0xffa03b00),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${_userData?['membershipTier'] ?? 'Bronze'} Member',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Color(0xffa03b00),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.edit, size: 20, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _statItem('Points', '${_userData?['points'] ?? 0}', Icons.star),
          _statItem(
            'Visits',
            '${_userData?['totalVisits'] ?? 0}',
            Icons.location_on,
          ),
          _statItem(
            'Reviews',
            '${_userReviews.length}', // 👈 Sửa ở đây: dùng số lượng review thực tế
            Icons.rate_review,
          ),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xffa03b00).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20, color: const Color(0xffa03b00)),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xff2e2f2d),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: TabBar(
        controller: _tabController,
        labelColor: const Color(0xffa03b00),
        unselectedLabelColor: Colors.grey[600],
        indicatorColor: const Color(0xffa03b00),
        indicatorWeight: 3,
        tabs: const [
          Tab(text: 'Posts'),
          Tab(text: 'Reviews'),
          Tab(text: 'Favorites'),
        ],
      ),
    );
  }

  Widget _buildPostsTab() {
    if (_isLoadingPosts) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_userPosts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.post_add, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No posts yet',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'Share your café experiences!',
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _userPosts.length,
      itemBuilder: (context, index) {
        final post = _userPosts[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _postCard(post),
        );
      },
    );
  }

  Widget _buildReviewsTab() {
    print(
      'Building Reviews Tab, reviews count: ${_userReviews.length}',
    ); // Thêm debug

    if (_isLoadingReviews) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_userReviews.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.rate_review, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No reviews yet',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'Visit coffee shops and leave a review!',
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _userReviews.length,
      itemBuilder: (context, index) {
        final review = _userReviews[index];
        print(
          'Building review card $index: ${review['content']}',
        ); // Thêm debug
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _reviewCard(review),
        );
      },
    );
  }

  Widget _buildFavoritesTab() {
    if (_isLoadingFavorites) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_userFavorites.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No favorites yet',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'Save your favorite coffee shops!',
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _userFavorites.length,
      itemBuilder: (context, index) {
        final shop = _userFavorites[index];
        return _favoriteCard(shop);
      },
    );
  }

  Widget _postCard(dynamic post) {
    final images = post['images'] != null
        ? List<String>.from(post['images'])
        : [];
    final coffeeShopName = post['coffeeShopName'];
    final hasVenue = coffeeShopName != null && coffeeShopName.isNotEmpty;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xffa03b00),
                      shape: BoxShape.circle,
                      image: _userData?['avatar'] != null
                          ? DecorationImage(
                              image: NetworkImage(_userData!['avatar']),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: _userData?['avatar'] == null
                        ? const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 20,
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _userData?['username'] ?? 'You',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _formatTimeAgo(post['createdAt']),
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (images.isNotEmpty)
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(
                        left: index == 0 ? 0 : 4,
                        right: index == images.length - 1 ? 0 : 4,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          images[index],
                          width: MediaQuery.of(context).size.width - 32,
                          height: 200,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                width: MediaQuery.of(context).size.width - 32,
                                height: 200,
                                color: Colors.grey[200],
                                child: const Icon(Icons.broken_image, size: 50),
                              ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (hasVenue)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 14,
                            color: Color(0xffa03b00),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            coffeeShopName,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xffa03b00),
                            ),
                          ),
                        ],
                      ),
                    ),
                  Text(
                    post['content'] ?? '',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[800],
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => _likePost(post['id'], post['likes'] ?? 0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.favorite_border,
                              size: 18,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${post['likes'] ?? 0}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: () => _showCommentDialog(
                          post['id'],
                          post['comments'] ?? 0,
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.chat_bubble_outline,
                              size: 18,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${post['comments'] ?? 0}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _likePost(int postId, int currentLikes) async {
    final success = await ApiService.likePost(postId);
    if (success) {
      setState(() {
        final index = _userPosts.indexWhere((p) => p['id'] == postId);
        if (index != -1) {
          _userPosts[index]['likes'] = currentLikes + 1;
        }
      });
    }
  }

  Widget _reviewCard(dynamic review) {
    print('Rendering review card with rating: ${review['rating']}');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.star, size: 16, color: Color(0xfff8ad1f)),
                const SizedBox(width: 4),
                Text(
                  '${review['rating'] ?? 0}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  _formatTimeAgo(review['createdAt']),
                  style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              review['content'] ?? '',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[700],
                height: 1.4,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  size: 12,
                  color: Color(0xffa03b00),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    review['coffeeShopName'] ?? 'Coffee Shop',
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _favoriteCard(dynamic shop) {
    final shopId = shop['coffeeShopId'] ?? shop['id'];
    final shopName = shop['coffeeShopName'] ?? shop['name'] ?? 'Coffee Shop';
    final shopImage = shop['coffeeShopImage'] ?? shop['imageUrl'] ?? '';
    final shopRating = shop['rating'] ?? 0;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/venue-detail', arguments: shopId);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: Image.network(
                shopImage,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[200],
                  child: const Icon(Icons.image, size: 30),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    shopName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        size: 12,
                        color: Color(0xfff8ad1f),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        shopRating.toStringAsFixed(1),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.favorite, color: Color(0xffa03b00)),
              onPressed: () async {
                final currentUser = ApiService.currentUser;
                if (currentUser == null) return;

                final success = await ApiService.removeFavoriteWithUserId(
                  shopId,
                  currentUser['id'],
                );
                if (success) {
                  _loadUserFavorites();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Removed from favorites'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCommentDialog(int postId, int currentComments) {
    final TextEditingController commentController = TextEditingController();
    List<dynamic> comments = [];
    bool isLoadingComments = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) {
          if (isLoadingComments) {
            ApiService.getComments(postId).then((loadedComments) {
              setStateDialog(() {
                comments = loadedComments;
                isLoadingComments = false;
              });
            });
          }

          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Comments',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Icon(Icons.close, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (isLoadingComments)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else if (comments.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32),
                          child: Text(
                            'No comments yet.\nBe the first to comment!',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      )
                    else
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.5,
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: comments.length,
                          itemBuilder: (context, index) {
                            final comment = comments[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      shape: BoxShape.circle,
                                      image: comment['userAvatar'] != null
                                          ? DecorationImage(
                                              image: NetworkImage(
                                                comment['userAvatar'],
                                              ),
                                              fit: BoxFit.cover,
                                            )
                                          : null,
                                    ),
                                    child: comment['userAvatar'] == null
                                        ? const Icon(Icons.person, size: 16)
                                        : null,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          comment['userName'] ?? 'Anonymous',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          comment['content'] ?? '',
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          _formatTimeAgo(comment['createdAt']),
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: commentController,
                            maxLines: 3,
                            decoration: InputDecoration(
                              hintText: 'Write a comment...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: BorderSide(
                                  color: Colors.grey[300]!,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: const BorderSide(
                                  color: Color(0xffa03b00),
                                  width: 2,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () async {
                            if (commentController.text.trim().isEmpty) return;

                            final currentUser = ApiService.currentUser;
                            if (currentUser == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please login to comment'),
                                ),
                              );
                              return;
                            }

                            final result = await ApiService.createComment(
                              postId: postId,
                              userId: currentUser['id'],
                              content: commentController.text.trim(),
                            );

                            if (result != null) {
                              final newComments = await ApiService.getComments(
                                postId,
                              );
                              setStateDialog(() {
                                comments = newComments;
                                commentController.clear();
                              });
                              setState(() {
                                final index = _userPosts.indexWhere(
                                  (p) => p['id'] == postId,
                                );
                                if (index != -1) {
                                  _userPosts[index]['comments'] =
                                      comments.length;
                                }
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Failed to add comment'),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffa03b00),
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(12),
                          ),
                          child: const Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _navButton(
              'Home',
              Icons.home,
              0,
              () => Navigator.pushReplacementNamed(context, '/home'),
            ),
            _navButton(
              'Search',
              Icons.search,
              1,
              () => Navigator.pushReplacementNamed(context, '/explore'),
            ),
            _fabCheckIn(() {}),
            _navButton(
              'Community',
              Icons.group,
              2,
              () => Navigator.pushReplacementNamed(context, '/community'),
            ),
            _navButton('Profile', Icons.person, 3, () {}, isActive: true),
          ],
        ),
      ),
    );
  }

  Widget _navButton(
    String label,
    IconData icon,
    int index,
    VoidCallback onTap, {
    bool isActive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? const Color(0xffa03b00) : Colors.grey[600],
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              color: isActive ? const Color(0xffa03b00) : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _fabCheckIn(VoidCallback onTap) {
    return Transform.translate(
      offset: const Offset(0, -16),
      child: GestureDetector(
        onTap: () {
          _showCheckInDialog(); // Bỏ qua onTap tham số
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xff9f3b00),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xff9f3b00).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.qr_code_scanner,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Check-in',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCheckInDialog() {
    int? selectedShopId;
    String? selectedShopName;
    final TextEditingController searchController = TextEditingController();
    List<dynamic> allShops = [];
    List<dynamic> filteredShops = [];
    bool isLoading = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) {
          // Load tất cả quán khi mở dialog
          if (allShops.isEmpty && isLoading) {
            ApiService.getCoffeeShops().then((shops) {
              setStateDialog(() {
                allShops = shops;
                filteredShops = shops;
                isLoading = false;
              });
            });
          }

          return AlertDialog(
            title: const Text('Check-in'),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Thanh tìm kiếm
                  TextField(
                    controller: searchController,
                    onChanged: (value) {
                      setStateDialog(() {
                        if (value.isEmpty) {
                          filteredShops = allShops;
                        } else {
                          filteredShops = allShops.where((shop) {
                            final name = shop['name']?.toLowerCase() ?? '';
                            return name.contains(value.toLowerCase());
                          }).toList();
                        }
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Tìm quán cà phê...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Danh sách quán
                  if (isLoading)
                    const Padding(
                      padding: EdgeInsets.all(32),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (filteredShops.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(32),
                      child: Text('Không tìm thấy quán nào'),
                    )
                  else
                    Container(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.5,
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: filteredShops.length,
                        itemBuilder: (context, index) {
                          final shop = filteredShops[index];
                          final isSelected = selectedShopId == shop['id'];
                          return ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                shop['imageUrl'] ?? '',
                                width: 44,
                                height: 44,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                      width: 44,
                                      height: 44,
                                      color: Colors.grey[200],
                                      child: const Icon(Icons.image, size: 24),
                                    ),
                              ),
                            ),
                            title: Text(
                              shop['name'] ?? 'Coffee Shop',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              shop['city'] ?? 'Nearby',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            trailing: isSelected
                                ? const Icon(
                                    Icons.check_circle,
                                    color: Color(0xff9f3b00),
                                  )
                                : null,
                            onTap: () {
                              setStateDialog(() {
                                selectedShopId = shop['id'];
                                selectedShopName = shop['name'];
                              });
                            },
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (selectedShopId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Vui lòng chọn quán')),
                    );
                    return;
                  }

                  Navigator.pop(context);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CheckinCodeScreen(
                        coffeeShopId: selectedShopId!,
                        coffeeShopName: selectedShopName ?? 'Coffee Shop',
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff9f3b00),
                ),
                child: const Text('Check-in'),
              ),
            ],
          );
        },
      ),
    );
  }
}
