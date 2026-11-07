import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';
import '../models/recommended_product.dart';
import '../services/agri_product_service.dart';

class NearbyKrishiKendrasWidget extends StatefulWidget {
  final double initialRadiusKm;

  const NearbyKrishiKendrasWidget({
    super.key,
    this.initialRadiusKm = 100.0,
  });

  @override
  State<NearbyKrishiKendrasWidget> createState() =>
      _NearbyKrishiKendrasWidgetState();
}

class _NearbyKrishiKendrasWidgetState extends State<NearbyKrishiKendrasWidget> {
  UserLocationInfo? _userLocation;
  bool _isLoadingGps = true;
  double _selectedRadiusKm = 100.0;
  List<KrishiKendra> _nearbyKendras = [];

  @override
  void initState() {
    super.initState();
    _selectedRadiusKm = widget.initialRadiusKm;
    _loadLocationAndKendras();
  }

  Future<void> _loadLocationAndKendras({bool forceRefresh = false}) async {
    if (mounted) {
      setState(() => _isLoadingGps = true);
    }

    final locInfo = await AgriProductService.getCurrentUserLocation(
      forceRefresh: forceRefresh,
    );

    final kendras = AgriProductService.getKendrasNearLocation(
      latitude: locInfo.latitude,
      longitude: locInfo.longitude,
      maxDistanceKm: _selectedRadiusKm,
    );

    if (mounted) {
      setState(() {
        _userLocation = locInfo;
        _nearbyKendras = kendras;
        _isLoadingGps = false;
      });
    }
  }

  void _onRadiusChanged(double newRadius) {
    if (_selectedRadiusKm == newRadius) return;
    setState(() {
      _selectedRadiusKm = newRadius;
      if (_userLocation != null) {
        _nearbyKendras = AgriProductService.getKendrasNearLocation(
          latitude: _userLocation!.latitude,
          longitude: _userLocation!.longitude,
          maxDistanceKm: _selectedRadiusKm,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final isMarathi = loc.language == AppLanguage.marathi;

    final locationTitle = _userLocation?.locationName ??
        (isMarathi
            ? 'बहादूरपूर / राहाता परिसर (शिर्डी जवळ, अहिल्यानगर)'
            : 'Bahadurpur / Rahata (Near Shirdi, Ahilyanagar)');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.storefront_rounded,
                          color: Color(0xFF1B5E20), size: 20),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        isMarathi
                            ? 'जवळची कृषी सेवा केंद्रे'
                            : 'Find Near Me (Agro Kendras)',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF14451D),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Refresh GPS Button
              InkWell(
                onTap: _isLoadingGps
                    ? null
                    : () => _loadLocationAndKendras(forceRefresh: true),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F6F0),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFD3E4D5)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_isLoadingGps)
                        const SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFF2E7D32),
                          ),
                        )
                      else
                        const Icon(Icons.my_location_rounded,
                            size: 13, color: Color(0xFF2E7D32)),
                      const SizedBox(width: 4),
                      Text(
                        isMarathi ? 'GPS ट्रॅक' : 'GPS Track',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1B5E20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // User Live Location Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F9F2),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFD6E8D6)),
            ),
            child: Row(
              children: [
                const Icon(Icons.place_rounded,
                    color: Color(0xFFD32F2F), size: 16),
                const SizedBox(width: 6),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isMarathi ? 'तुमचे शेत / घर स्थान:' : 'Your Location:',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF5A7262),
                        ),
                      ),
                      Text(
                        locationTitle,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF14451D),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: (_userLocation?.isLiveGps ?? false)
                        ? const Color(0xFFC8E6C9)
                        : const Color(0xFFFFF3DC),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    (_userLocation?.isLiveGps ?? false)
                        ? (isMarathi ? 'थेट GPS' : 'Live GPS')
                        : (isMarathi ? 'बहादूरपूर (शेत)' : 'Farmland'),
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w800,
                      color: (_userLocation?.isLiveGps ?? false)
                          ? const Color(0xFF1B5E20)
                          : const Color(0xFFD97706),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Radius filter chips
          Row(
            children: [
              _buildRadiusChip('२५ km', 25.0),
              const SizedBox(width: 6),
              _buildRadiusChip('५० km', 50.0),
              const SizedBox(width: 6),
              _buildRadiusChip('१०० km (शिफारस)', 100.0),
              const SizedBox(width: 6),
              _buildRadiusChip('सर्व', 400.0),
            ],
          ),
          const SizedBox(height: 12),

          // Kendra List
          if (_isLoadingGps && _nearbyKendras.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF2E7D32),
                ),
              ),
            )
          else if (_nearbyKendras.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF7FAF5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  isMarathi
                      ? 'या परिसराच्या ${_selectedRadiusKm.toInt()} km अंतरात केंद्रे उपलब्ध नाहीत.'
                      : 'No Krishi Kendras found within ${_selectedRadiusKm.toInt()} km.',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF5A7262),
                  ),
                ),
              ),
            )
          else
            ..._nearbyKendras.map((k) => _buildKendraCard(context, k, isMarathi)),
        ],
      ),
    );
  }

  Widget _buildRadiusChip(String label, double radius) {
    final isSelected = (_selectedRadiusKm == radius);
    return Expanded(
      child: GestureDetector(
        onTap: () => _onRadiusChanged(radius),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF165228) : const Color(0xFFF1F6EE),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? const Color(0xFF165228) : const Color(0xFFD8E5D9),
            ),
          ),
          alignment: Alignment.center,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? Colors.white : const Color(0xFF14451D),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKendraCard(
      BuildContext context, KrishiKendra k, bool isMarathi) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAF5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFDCE8DC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Shop name & Licensed tag
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  isMarathi ? k.marathiName : k.name,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF14451D),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                decoration: BoxDecoration(
                  color: const Color(0xFFD7EBD8),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.verified_rounded,
                        color: Color(0xFF2E7D32), size: 11),
                    const SizedBox(width: 3),
                    Text(
                      isMarathi ? 'परवानाधारक' : 'Licensed',
                      style: const TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),

          // Address & Distance row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFFC8E6C9)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.near_me_rounded,
                        color: Color(0xFF1B5E20), size: 11),
                    const SizedBox(width: 3),
                    Text(
                      '${k.distanceKm} km',
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1B5E20),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  isMarathi ? k.marathiAddress : k.address,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF5A7262),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Stock Available tag
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFFE0EBE0)),
            ),
            child: Row(
              children: [
                const Icon(Icons.inventory_2_outlined,
                    color: Color(0xFF2E7D32), size: 12),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    isMarathi ? k.inStockSummaryMarathi : k.inStockSummary,
                    style: const TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E7D32),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Action Buttons: Call Shop & Directions
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => AgriProductService.callShop(context, k),
                  icon: const Icon(Icons.call_rounded, size: 14),
                  label: Text(isMarathi ? 'कॉल करा' : 'Call Shop'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF14451D),
                    side: const BorderSide(color: Color(0xFFC8E6C9)),
                    minimumSize: const Size(0, 36),
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () =>
                      AgriProductService.openDirections(context, k),
                  icon: const Icon(Icons.directions_rounded, size: 14),
                  label: Text(isMarathi ? 'दिशानिर्देश' : 'Directions'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF165228),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    minimumSize: const Size(0, 36),
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

