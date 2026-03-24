import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:convert';
import 'package:btl_mobile/services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:btl_mobile/screens/checkin/checkin_code_screen.dart';

const Color _colorSecondaryContainer = Color(0xFFFFD8C2);
const Color _colorOnPrimaryContainer = Color(0xFFFFFFFF);
const Color _colorPrimary = Color(0xFF9F3B00);
const Color _colorSecondary = Color(0xFF934600);
const Color _colorSurface = Color(0xFFFFF4F0);
const Color _colorSurfaceContainer = Color(0xFFFFE3D3);
const Color _colorSurfaceContainerLow = Color(0xFFFFEDE4);
const Color _colorSurfaceContainerLowest = Color(0xFFFFFFFF);
const Color _colorOnSurface = Color(0xFF4B2508);
const Color _colorOnSurfaceVariant = Color(0xFF805030);
const Color _colorOutlineVariant = Color(0xFFDCA07A);
const Color _colorTertiaryContainer = Color(0xFFF8AD1F);
const Color _colorOnTertiaryContainer = Color(0xFF4F3300);
const Color _colorOnSecondaryContainer = Color(0xFF743600);
const Color _colorPrimaryContainer = Color(0xFFFF793A);

class VenueDetailScreen extends StatefulWidget {
  final int? venueId;

  const VenueDetailScreen({super.key, this.venueId});

  @override
  State<VenueDetailScreen> createState() => _VenueDetailScreenState();
}

class _VenueDetailScreenState extends State<VenueDetailScreen> {
  int _currentNavIndex = 0;
  bool _isLoading = true;
  Map<String, dynamic>? _venueData;
  List<dynamic> _reviews = [];
  bool _isFavorite = false;
  bool _hasReviewed = false;
  Map<String, dynamic>? _myReview;

  int? _actualVenueId;

  // Review dialog controllers
  final TextEditingController _reviewController = TextEditingController();
  double _selectedRating = 5.0;

  @override
  void initState() {
    super.initState();
    // Lấy venueId từ arguments nếu widget.venueId null
    _actualVenueId = widget.venueId;
    if (_actualVenueId == null) {
      final args = ModalRoute.of(context)?.settings.arguments;
      // Nhận int trực tiếp (giống file home)
      if (args is int) {
        _actualVenueId = args;
        print('Received venueId from arguments (int): $_actualVenueId');
      }
    }
    _loadVenueDetail();
    _checkFavoriteStatus();
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  // Hàm hiển thị ảnh fullscreen
  void _showFullscreenImage(String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withOpacity(0.9),
            child: Center(
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[800],
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.broken_image,
                            size: 64,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Không thể tải ảnh',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _loadVenueDetail() async {
    if (_actualVenueId == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final venue = await ApiService.getCoffeeShopDetail(_actualVenueId!);
      final reviews = await ApiService.getReviewsByCoffeeShop(_actualVenueId!);

      // Kiểm tra user đã review chưa
      final currentUser = ApiService.currentUser;
      Map<String, dynamic>? myReview;
      bool hasReviewed = false;

      if (currentUser != null) {
        myReview = reviews.firstWhere(
          (review) => review['userId'] == currentUser['id'],
          orElse: () => null,
        );
        hasReviewed = myReview != null;
      }

      setState(() {
        _venueData = venue;
        _reviews = reviews;
        _hasReviewed = hasReviewed;
        _myReview = myReview;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading venue: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _checkFavoriteStatus() async {
    if (_actualVenueId != null) {
      final favorite = await ApiService.isFavorite(_actualVenueId!);
      setState(() {
        _isFavorite = favorite;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    if (_actualVenueId == null) return;

    bool success;
    if (_isFavorite) {
      success = await ApiService.removeFavorite(_actualVenueId!);
    } else {
      success = await ApiService.addFavorite(_actualVenueId!);
    }

    if (success) {
      setState(() {
        _isFavorite = !_isFavorite;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isFavorite ? 'Đã thêm vào yêu thích' : 'Đã xóa khỏi yêu thích',
          ),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  Future<void> _submitOrUpdateReview({bool isEdit = false}) async {
    if (_reviewController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập nội dung đánh giá'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_actualVenueId == null) return;

    final currentUser = ApiService.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng đăng nhập để đánh giá'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      Map<String, dynamic>? result;

      if (isEdit && _myReview != null) {
        // Cập nhật review cũ
        result = await ApiService.updateReview(
          _myReview!['id'],
          _selectedRating.toInt(),
          _reviewController.text.trim(),
          null,
        );
      } else {
        // Tạo review mới
        result = await ApiService.createReview(
          _actualVenueId!,
          _selectedRating.toInt(),
          _reviewController.text.trim(),
          null,
          userId: currentUser['id'],
        );
      }

      if (!mounted) return;
      Navigator.pop(context);

      if (result != null) {
        // Reload reviews
        final reviews = await ApiService.getReviewsByCoffeeShop(
          _actualVenueId!,
        );

        // Cập nhật myReview
        final updatedMyReview = reviews.firstWhere(
          (review) => review['userId'] == currentUser['id'],
          orElse: () => null,
        );

        setState(() {
          _reviews = reviews;
          _myReview = updatedMyReview;
          _hasReviewed = updatedMyReview != null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEdit ? '✏️ Đã cập nhật đánh giá!' : '✨ Cảm ơn bạn đã đánh giá!',
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );

        _reviewController.clear();
        _selectedRating = 5.0;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              '❌ Bạn đã đánh giá quán này rồi! Mỗi người chỉ được đánh giá 1 lần.',
            ),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e'), backgroundColor: Colors.red),
      );
    }
  }

  void _showReviewDialog() {
    _reviewController.clear();
    _selectedRating = 5.0;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Write a Review',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _colorOnSurface,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Rating',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _colorOnSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(5, (index) {
                      return IconButton(
                        onPressed: () {
                          setStateDialog(() {
                            _selectedRating = (index + 1).toDouble();
                          });
                        },
                        icon: Icon(
                          index < _selectedRating
                              ? Icons.star
                              : Icons.star_border,
                          color: _colorTertiaryContainer,
                          size: 32,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Your Review',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _colorOnSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _reviewController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Share your experience...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: _colorOutlineVariant.withOpacity(0.5),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: _colorPrimary,
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: _colorSurfaceContainerLowest,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _reviewController.clear();
                            _selectedRating = 5.0;
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 16,
                              color: _colorOnSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _submitOrUpdateReview(isEdit: false);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _colorPrimary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Submit',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showEditReviewDialog() {
    // Load nội dung review hiện tại
    _reviewController.text = _myReview?['content'] ?? '';
    _selectedRating = (_myReview?['rating'] ?? 5).toDouble();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Edit Your Review',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _colorOnSurface,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Rating',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _colorOnSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(5, (index) {
                      return IconButton(
                        onPressed: () {
                          setStateDialog(() {
                            _selectedRating = (index + 1).toDouble();
                          });
                        },
                        icon: Icon(
                          index < _selectedRating
                              ? Icons.star
                              : Icons.star_border,
                          color: _colorTertiaryContainer,
                          size: 32,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Your Review',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _colorOnSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _reviewController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Update your experience...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: _colorOutlineVariant.withOpacity(0.5),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: _colorPrimary,
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: _colorSurfaceContainerLowest,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _reviewController.clear();
                            _selectedRating = 5.0;
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 16,
                              color: _colorOnSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _submitOrUpdateReview(isEdit: true);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _colorPrimary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Update',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String get _shopName {
    return _venueData?['name'] ?? 'The Roasted Bean';
  }

  double get _rating {
    if (_venueData?['rating'] != null && _venueData!['rating'] > 0) {
      return _venueData!['rating'].toDouble();
    }
    if (_reviews.isNotEmpty) {
      final totalRating = _reviews.fold<int>(
        0,
        (sum, review) => sum + (review['rating'] as int),
      );
      return totalRating / _reviews.length;
    }
    return 0.0;
  }

  int get _totalReviews {
    return _venueData?['totalReviews'] ?? _reviews.length;
  }

  String get _priceRange {
    return _venueData?['priceRange'] ?? '\$\$';
  }

  String get _address {
    return _venueData?['address'] ??
        '124 Artisan Alley, Creative District\nSan Francisco, CA 94103';
  }

  String get _imageUrl {
    return _venueData?['imageUrl'] ??
        'https://lh3.googleusercontent.com/aida-public/AB6AXuD7gvByok6ygUOqgD9kZporoKWyXMLjOigZrpQ7lyEbAs4xVd3xvFbqQs05qtnNqFx_0SvFpGvKs0w5ngRIB7HUtf8a9XXmRnBbIzgahIMtuU6Sbf3Fd2jCD8kuiyqfskR42scGdVWgTDZDTJos0Ppgnk3VqL8URJObZj-iqM7XD74y_cj8uaAwZ8vaAsK4u_6eB8PXL4jCHJ5kZLGS6xegdS0P_6dlTlxb3nNJ8js_Ymbx7EL0DMeOgoFnr9LOXNAGiqW71a--FG0';
  }

  List<String> get _galleryImages {
    if (_venueData?['images'] != null && _venueData!['images'] is List) {
      return List<String>.from(_venueData!['images']);
    }
    return [_imageUrl];
  }

  List<Map<String, dynamic>> get _menuItems {
    if (_venueData?['menu'] != null && _venueData!['menu'] is List) {
      return List<Map<String, dynamic>>.from(_venueData!['menu']);
    }
    return [
      {
        'name': 'Double Espresso',
        'description': 'Ethopian Yirgacheffe',
        'price': '\$4.50',
        'imageUrl':
            'https://lh3.googleusercontent.com/aida-public/AB6AXuD7t-FL58M4NNQOFgd33iWftaUgVMfxQoUsDdTJUSileRCDDdNi3ql4cbKjNd8RMm5mGaWZPZJ5DmtUimp41L3ODh5RV0iCCniBgVxkeJ9ZenpRhB0dQFazlfz2E61VG9q_r7k1V8YGgTY9935hCiQoIYMl1pAKsFIm5tk4w0i7BYh2gqjVMaMBWQMjOlP-IP_4EW238DYdBP5vmupoGmgU9qHWBXRUEsTuTuXFz17s2PJadJoF98yG_7CugX_yFCI16xBiVF0ZaltA',
      },
      {
        'name': 'Signature Avo-Toast',
        'description': 'Sourdough & Chili Flakes',
        'price': '\$14.00',
        'imageUrl':
            'https://lh3.googleusercontent.com/aida-public/AB6AXuDxCR2u9ZAPqQjPDneQrrTX8aMpDuXyZFZF2oN_Z1u_21klp_c8tdwuggymfYSxfCjHzaFsTUCSPIQ1D4F-HZGn909WWntnIsp566_yaS43i39ajt4T3o8Y5qN1XjpBexEeITdsekswWriza5h-xNxfm0qJU9U9QyWboXqN6jFhxSUlxKr1iyxrIFOnj_mX5Iufu6oxoOy7UaPJuXX9Y-k9sjKTIYRxzJo7zw35MRNAtaqcEVtwN0Cb3fz6MUEdUrTsKExl43l0WV0',
      },
      {
        'name': '12hr Cold Brew',
        'description': 'Nutty & Smooth',
        'price': '\$6.50',
        'imageUrl':
            'https://lh3.googleusercontent.com/aida-public/AB6AXuDBVo5pp8-B0MX8w3kZ962idnWHah-xGdnWqTAD-v4QRaAbPePJyVpSoviuposZjtcGHJVzrFwlDqctVQAj26ngfB_KSaw_p3jDBLzi0H4R2fwbjglZNx1_R9qBW4EhgyAYCvviE3As1FVoVnh96w5Ym-7Jqu85V_TBjUZdxmSGLDd_ldQHsYMQnC3rbAuCAG1DPu_70XOQGxyuF0DFZxeDHCfLZRGnwEUzd7GMJnOBr1LQxa6x8jbumWFdteGWuXTcylC5tRlrCwg',
      },
    ];
  }

  Map<String, String> get _openingHours {
    final hoursData = _venueData?['openingHours'];

    if (hoursData != null) {
      if (hoursData is Map) {
        return Map<String, String>.from(hoursData);
      }
      if (hoursData is String) {
        try {
          final decoded = jsonDecode(hoursData);
          return Map<String, String>.from(decoded);
        } catch (e) {
          print('Error parsing openingHours: $e');
        }
      }
    }

    return {
      'Monday': '07:30 - 18:00',
      'Tuesday': '07:30 - 18:00',
      'Wednesday': '07:30 - 18:00',
      'Thursday': '07:30 - 18:00',
      'Friday': '07:30 - 20:00',
      'Saturday': '08:00 - 20:00',
      'Sunday': '08:00 - 17:00',
    };
  }

  String _getPriceRangeText(String? priceRange) {
    if (priceRange == r'$$$') return 'Expensive Pricing';
    if (priceRange == r'$$') return 'Moderate Pricing';
    return 'Affordable Pricing';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: _colorSurface,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: _colorSurface,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom AppBar
            Container(
              padding: const EdgeInsets.fromLTRB(8, 48, 8, 8),
              decoration: BoxDecoration(
                color: Color.lerp(_colorSurface, Colors.black, 0.05),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: _colorOnSurface),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Text(
                      'Go & Chill',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _colorOnSurface,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.share, color: _colorOnSurface),
                    onPressed: () {},
                    style: IconButton.styleFrom(
                      backgroundColor: _colorSurfaceContainerLow,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: _isFavorite ? Colors.red : _colorOnSurface,
                    ),
                    onPressed: _toggleFavorite,
                    style: IconButton.styleFrom(
                      backgroundColor: _colorSurfaceContainerLow,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
            _heroGallery(_galleryImages),
            const SizedBox(height: 16),
            _headerInfo(_shopName, _rating, _totalReviews, _priceRange),
            const SizedBox(height: 24),
            _locationHoursGrid(_address, _openingHours),
            const SizedBox(height: 32),
            _menuHighlights(),
            const SizedBox(height: 32),
            _communityBuzz(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _heroGallery(List<String> images) {
    final displayImages = images.take(3).toList();
    final remainingCount = images.length - 3;

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final responsiveHeight = (screenHeight * 0.25).clamp(200.0, 400.0);

    if (displayImages.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          height: responsiveHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: _colorSurfaceContainer,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.store,
                size: 48,
                color: _colorOnSurfaceVariant.withOpacity(0.5),
              ),
              const SizedBox(height: 8),
              Text(
                'No images available',
                style: TextStyle(color: _colorOnSurfaceVariant, fontSize: 12),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          SizedBox(
            height: responsiveHeight,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: () => _showFullscreenImage(displayImages[0]),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        displayImages[0],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: _colorSurfaceContainer,
                          child: const Icon(Icons.image),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (displayImages.length > 1) {
                              _showFullscreenImage(displayImages[1]);
                            }
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: displayImages.length > 1
                                ? Image.network(
                                    displayImages[1],
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                              color: _colorSurfaceContainer,
                                              child: const Icon(Icons.image),
                                            ),
                                  )
                                : Container(
                                    color: _colorSurfaceContainer,
                                    child: const Center(
                                      child: Icon(
                                        Icons.image,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (displayImages.length > 2) {
                              _showFullscreenImage(displayImages[2]);
                            }
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                if (displayImages.length > 2)
                                  Image.network(
                                    displayImages[2],
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                    color: remainingCount > 0
                                        ? Colors.black.withOpacity(0.4)
                                        : null,
                                    colorBlendMode: remainingCount > 0
                                        ? BlendMode.darken
                                        : null,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                              color: _colorSurfaceContainer,
                                              child: const Icon(Icons.image),
                                            ),
                                  )
                                else
                                  Container(
                                    color: _colorSurfaceContainer,
                                    child: const Center(
                                      child: Icon(
                                        Icons.image,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                if (remainingCount > 0)
                                  const Center(
                                    child: Text(
                                      '+',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _colorPrimary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.verified, size: 10, color: _colorPrimary),
                  const SizedBox(width: 4),
                  const Text(
                    'Top Rated 2024',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                      color: _colorPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerInfo(
    String name,
    double rating,
    int totalReviews,
    String priceRange,
  ) {
    final ratingText = rating > 0 ? rating.toStringAsFixed(1) : "New";
    final reviewText = totalReviews > 0 ? "($totalReviews)" : "(No reviews)";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: _colorOnSurface,
              height: 1.1,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _colorTertiaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.star,
                      size: 12,
                      color: _colorOnTertiaryContainer,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      ratingText,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: _colorOnTertiaryContainer,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      reviewText,
                      style: TextStyle(
                        fontSize: 10,
                        color: _colorOnTertiaryContainer.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Row(
                children: [
                  const Icon(
                    Icons.payments,
                    size: 12,
                    color: _colorOnSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _getPriceRangeText(priceRange),
                    style: const TextStyle(
                      fontSize: 11,
                      color: _colorOnSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                if (_actualVenueId != null) {
                  // Mở màn hình nhập mã code
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CheckinCodeScreen(
                        coffeeShopId: _actualVenueId!,
                        coffeeShopName: _shopName,
                      ),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.qr_code_scanner, size: 18),
              label: const Text('Check-in Now', style: TextStyle(fontSize: 13)),
              style: ElevatedButton.styleFrom(
                backgroundColor: _colorPrimary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openMaps(String address) async {
    final encodedAddress = Uri.encodeComponent(address);
    final googleMapsUrl = Uri.parse(
      'https://www.google.com/maps/search/$encodedAddress',
    );
    final googleMapsAppUrl = Uri.parse('comgooglemaps://?q=$encodedAddress');

    try {
      if (await canLaunchUrl(googleMapsAppUrl)) {
        await launchUrl(googleMapsAppUrl);
      } else {
        await launchUrl(googleMapsUrl);
      }
    } catch (e) {
      await launchUrl(googleMapsUrl);
    }
  }

  Widget _locationHoursGrid(String address, Map<String, String> hours) {
    final weekdays = hours.keys.toList();
    final times = hours.values.toList();

    final dayShortMap = {
      'Monday': 'Mon',
      'Tuesday': 'Tue',
      'Wednesday': 'Wed',
      'Thursday': 'Thu',
      'Friday': 'Fri',
      'Saturday': 'Sat',
      'Sunday': 'Sun',
    };

    final now = DateTime.now();
    const fullWeekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    final todayFull = fullWeekdays[now.weekday - 1];
    final todayShort = dayShortMap[todayFull] ?? todayFull;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _colorSurfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Location',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: _colorOnSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: _colorPrimary,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          address,
                          style: const TextStyle(
                            color: _colorOnSurfaceVariant,
                            height: 1.3,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      _openMaps(address);
                    },
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[300],
                      ),
                      child: const Center(
                        child: Text(
                          'Open in Maps',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: _colorOnSurface,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _colorSurfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hours',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: _colorOnSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...weekdays.take(5).map((day) {
                    final index = weekdays.indexOf(day);
                    final shortDay = dayShortMap[day] ?? day.substring(0, 3);
                    final isToday = shortDay == todayShort;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            shortDay,
                            style: TextStyle(
                              fontWeight: isToday
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: isToday ? _colorPrimary : _colorOnSurface,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            times[index],
                            style: TextStyle(
                              fontWeight: isToday
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                              color: isToday
                                  ? _colorPrimary
                                  : _colorOnSurfaceVariant,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _colorTertiaryContainer.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.bolt, size: 12, color: _colorPrimary),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            'Peak: 10AM-2PM',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: _colorOnSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuHighlights() {
    final menu = _menuItems;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Menu Highlights',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: _colorOnSurface,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'View',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _colorPrimary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_forward,
                    size: 16,
                    color: _colorPrimary,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: menu.map((item) {
                return GestureDetector(
                  onTap: () => _showFullscreenImage(
                    item['imageUrl'] ?? 'https://via.placeholder.com/300',
                  ),
                  child: Container(
                    width: 240,
                    margin: const EdgeInsets.only(right: 16),
                    child: _menuItem(
                      item['name'] ?? 'Item',
                      item['description'] ?? '',
                      item['price'] ?? '\$0.00',
                      item['imageUrl'] ?? 'https://via.placeholder.com/300',
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuItem(
    String name,
    String description,
    String price,
    String imageUrl,
  ) {
    return Container(
      width: 240,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _colorSurfaceContainerLowest,
        border: Border.all(color: _colorOutlineVariant.withOpacity(0.1)),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AspectRatio(
            aspectRatio: 1.2,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: _colorSurfaceContainer,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: _colorSurfaceContainer,
                    child: const Icon(Icons.restaurant),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: _colorOnSurface,
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 10,
                        color: _colorOnSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                price,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: _colorPrimary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _communityBuzz() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Community Buzz',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: _colorOnSurface,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _colorSurfaceContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Text(
                      'Sort by: Recent',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _colorOnSurface,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.expand_more,
                      size: 16,
                      color: _colorOnSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          if (_hasReviewed && _myReview != null) ...[
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                border: Border.all(color: _colorPrimary.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(12),
                color: _colorPrimary.withOpacity(0.05),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _colorPrimary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Your Review',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.edit, size: 18),
                          onPressed: _showEditReviewDialog,
                          tooltip: 'Edit review',
                        ),
                      ],
                    ),
                  ),
                  _reviewCard(
                    _myReview!['userName'] ??
                        ApiService.currentUser?['username'] ??
                        'You',
                    _myReview!['isVerified'] == true ? "Verified ✓" : "User",
                    _myReview!['content'] ?? '',
                    _formatTime(_myReview!['createdAt']),
                    (_myReview!['likes'] ?? 0).toString(),
                    (_myReview!['comments'] ?? 0).toString(),
                    _myReview!['userAvatar'],
                    _myReview!['images'] != null
                        ? List<String>.from(_myReview!['images'])
                        : [],
                  ),
                ],
              ),
            ),
          ],

          if (_reviews.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text('Chưa có đánh giá nào'),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _reviews.length,
              itemBuilder: (context, index) {
                final review = _reviews[index];
                final currentUser = ApiService.currentUser;
                final isMyReview =
                    currentUser != null &&
                    review['userId'] == currentUser['id'];

                if (isMyReview) return const SizedBox.shrink();

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _reviewCard(
                    review['userName'] ?? 'Anonymous',
                    review['isVerified'] == true ? "Verified ✓" : "User",
                    review['content'] ?? '',
                    _formatTime(review['createdAt']),
                    (review['likes'] ?? 0).toString(),
                    (review['comments'] ?? 0).toString(),
                    review['userAvatar'],
                    review['images'] != null
                        ? List<String>.from(review['images'])
                        : [],
                  ),
                );
              },
            ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _hasReviewed
                  ? _showEditReviewDialog
                  : _showReviewDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: _hasReviewed
                    ? _colorSurfaceContainerLow
                    : _colorPrimary,
                foregroundColor: _hasReviewed ? _colorOnSurface : Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                _hasReviewed ? '✏️ Edit Your Review' : '✍️ Write a review',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(String? dateTime) {
    if (dateTime == null) return 'Recently';
    try {
      final date = DateTime.parse(dateTime);
      final difference = DateTime.now().difference(date);
      if (difference.inDays > 7)
        return '${(difference.inDays / 7).floor()} weeks ago';
      if (difference.inDays > 0) return '${difference.inDays} days ago';
      if (difference.inHours > 0) return '${difference.inHours} hours ago';
      if (difference.inMinutes > 0)
        return '${difference.inMinutes} minutes ago';
      return 'Just now';
    } catch (e) {
      return 'Recently';
    }
  }

  Widget _reviewCard(
    String name,
    String subtitle,
    String review,
    String time,
    String likes,
    String comments,
    String? avatarUrl,
    List<String> photos,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _colorSurfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (avatarUrl != null) {
                        _showFullscreenImage(avatarUrl);
                      }
                    },
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _colorPrimaryContainer,
                          width: 2,
                        ),
                      ),
                      child: avatarUrl != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(22),
                              child: Image.network(
                                avatarUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                      color: _colorSecondaryContainer,
                                      child: const Icon(
                                        Icons.person,
                                        color: _colorOnSecondaryContainer,
                                      ),
                                    ),
                              ),
                            )
                          : Container(
                              color: _colorSecondaryContainer,
                              child: const Icon(
                                Icons.person,
                                color: _colorOnSecondaryContainer,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: _colorOnSurface,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: _colorOnSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (subtitle.contains('Verified'))
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _colorOnSecondaryContainer.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.verified_user,
                        size: 10,
                        color: _colorOnSecondaryContainer,
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'Verified',
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                          color: _colorOnSecondaryContainer,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            review,
            style: const TextStyle(
              color: _colorOnSurfaceVariant,
              height: 1.4,
              fontSize: 13,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          if (photos.isNotEmpty) ...[
            const SizedBox(height: 12),
            SizedBox(
              height: 80,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: photos
                    .take(3)
                    .map(
                      (photo) => GestureDetector(
                        onTap: () => _showFullscreenImage(photo),
                        child: Container(
                          width: 80,
                          height: 80,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: _colorSurfaceContainer,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              photo,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    color: _colorSurfaceContainer,
                                    child: const Icon(Icons.image, size: 30),
                                  ),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: _colorOutlineVariant.withOpacity(0.2),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _interactionButton(Icons.thumb_up_outlined, likes),
                    const SizedBox(width: 16),
                    _interactionButton(Icons.chat_bubble_outline, comments),
                  ],
                ),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: _colorOnSurfaceVariant,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _interactionButton(IconData icon, String count) {
    return Row(
      children: [
        Icon(icon, size: 14, color: _colorOnSurfaceVariant),
        const SizedBox(width: 4),
        Text(
          count,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: _colorOnSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _fab() {
    return FloatingActionButton(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tính năng đang phát triển'),
            duration: Duration(seconds: 1),
          ),
        );
      },
      backgroundColor: _colorOnSurface,
      foregroundColor: _colorSurface,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: const Icon(Icons.add_shopping_cart),
    );
  }
}
