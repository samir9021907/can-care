import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../models/country_code.dart';

export '../models/country_code.dart';

/// Clean mobile number input with interactive country code selector dropdown matching CaneCare AI theme
class MobileNumberField extends StatefulWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final CountryCode? selectedCountry;
  final ValueChanged<CountryCode>? onCountryChanged;
  final String? errorMessage;
  final bool hasError;

  const MobileNumberField({
    super.key,
    this.controller,
    this.onChanged,
    this.selectedCountry,
    this.onCountryChanged,
    this.errorMessage,
    this.hasError = false,
  });

  @override
  State<MobileNumberField> createState() => _MobileNumberFieldState();
}

class _MobileNumberFieldState extends State<MobileNumberField> {
  late CountryCode _currentCountry;

  @override
  void initState() {
    super.initState();
    _currentCountry = widget.selectedCountry ?? kSupportedCountries.first;
  }

  @override
  void didUpdateWidget(covariant MobileNumberField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedCountry != null &&
        widget.selectedCountry != _currentCountry) {
      _currentCountry = widget.selectedCountry!;
    }
  }

  void _openCountryPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return _CountryPickerSheet(
          selectedCountry: _currentCountry,
          onSelect: (country) {
            setState(() => _currentCountry = country);
            widget.onCountryChanged?.call(country);
            Navigator.pop(ctx);
          },
        );
      },
    );
  }

  String _getHintForCountry(CountryCode c) {
    switch (c.code) {
      case '+91':
        return '98765 43210';
      case '+1':
        return '555 123 4567';
      case '+44':
        return '7911 123456';
      case '+55':
        return '11 98765 4321';
      case '+61':
        return '412 345 678';
      case '+971':
        return '50 123 4567';
      default:
        return 'Mobile number';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isError =
        widget.hasError || (widget.errorMessage != null && widget.errorMessage!.isNotEmpty);
    final borderColor = isError ? AppColors.error : AppColors.inputBorder;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 52,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: borderColor,
              width: isError ? 1.4 : 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            children: [
              // Interactive Country Code Selector Pill
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _openCountryPicker(context),
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(11),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    height: double.infinity,
                    decoration: const BoxDecoration(
                      border: Border(
                        right: BorderSide(color: Color(0xFFE2ECE0), width: 1.2),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _currentCountry.flag,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _currentCountry.code,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.darkGreen,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.arrow_drop_down,
                          color: Color(0xFF6B8A73),
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Phone number input
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(_currentCountry.maxLength),
                  ],
                  onChanged: widget.onChanged,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF1F2937),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                  decoration: InputDecoration(
                    hintText: _getHintForCountry(_currentCountry),
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF94A89A),
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),

              if (isError)
                const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Icon(
                    Icons.error_outline_rounded,
                    color: AppColors.error,
                    size: 19,
                  ),
                ),
            ],
          ),
        ),
        if (isError && widget.errorMessage != null) ...[
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              widget.errorMessage!,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// Searchable modal bottom sheet for choosing from multiple countries
class _CountryPickerSheet extends StatefulWidget {
  final CountryCode selectedCountry;
  final ValueChanged<CountryCode> onSelect;

  const _CountryPickerSheet({
    required this.selectedCountry,
    required this.onSelect,
  });

  @override
  State<_CountryPickerSheet> createState() => _CountryPickerSheetState();
}

class _CountryPickerSheetState extends State<_CountryPickerSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<CountryCode> _filtered = kSupportedCountries;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearch);
  }

  void _onSearch() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filtered = kSupportedCountries;
      } else {
        _filtered = kSupportedCountries.where((c) {
          final nameMatch = c.name.toLowerCase().contains(query);
          final codeMatch = c.code.toLowerCase().contains(query);
          final isoMatch = c.isoCode.toLowerCase().contains(query);
          return nameMatch || codeMatch || isoMatch;
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final maxHeight = mediaQuery.size.height * 0.72;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Container(
          height: maxHeight,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              // Grab handle
              Container(
                width: 44,
                height: 4.5,
                decoration: BoxDecoration(
                  color: const Color(0xFFD4E2D2),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(height: 14),

              // Title bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    const Text(
                      'Select Country',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkGreen,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: Color(0xFF5A7262)),
                      onPressed: () => Navigator.pop(context),
                      splashRadius: 20,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Container(
                  height: 46,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F8F3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2ECE0)),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: Color(0xFF6B8A73),
                        size: 20,
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(
                                Icons.clear_rounded,
                                color: Color(0xFF6B8A73),
                                size: 18,
                              ),
                              onPressed: () {
                                _searchController.clear();
                              },
                            )
                          : null,
                      hintText: 'Search country or code...',
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF94A89A),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 13),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),
              const Divider(height: 1, color: Color(0xFFEEF4EC)),

              // Countries List
              Expanded(
                child: _filtered.isEmpty
                    ? const Center(
                        child: Text(
                          'No countries found',
                          style: TextStyle(
                            color: Color(0xFF6B8A73),
                            fontSize: 14,
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: _filtered.length,
                        separatorBuilder: (_, _) =>
                            const Divider(height: 1, indent: 64, color: Color(0xFFF0F5EE)),
                        itemBuilder: (context, index) {
                          final country = _filtered[index];
                          final isSelected = country.code == widget.selectedCountry.code &&
                              country.isoCode == widget.selectedCountry.isoCode;

                          return InkWell(
                            onTap: () => widget.onSelect(country),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    country.flag,
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Text(
                                      country.name,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: isSelected
                                            ? FontWeight.w700
                                            : FontWeight.w500,
                                        color: isSelected
                                            ? AppColors.darkGreen
                                            : const Color(0xFF263238),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? const Color(0xFFE8F5E9)
                                          : const Color(0xFFF1F6F0),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      country.code,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: isSelected
                                            ? const Color(0xFF2E7D32)
                                            : const Color(0xFF5A7262),
                                      ),
                                    ),
                                  ),
                                  if (isSelected) ...[
                                    const SizedBox(width: 10),
                                    const Icon(
                                      Icons.check_circle_rounded,
                                      color: Color(0xFF2E7D32),
                                      size: 20,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
