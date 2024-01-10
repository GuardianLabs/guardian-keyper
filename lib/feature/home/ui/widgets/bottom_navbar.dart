import 'package:flutter_svg/flutter_svg.dart';

import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/feature/message/ui/widgets/requests_icon.dart';

import '../home_presenter.dart';

class BottomNavBar extends StatelessWidget {
  static const _iconSize = 32.0;
  static const _homeSvg = 'assets/icons/home.svg';
  static const _vaultsSvg = 'assets/icons/home_vaults.svg';
  static const _shardsSvg = 'assets/icons/home_shards.svg';

  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final presenter = context.watch<HomePresenter>();
    final bottomNavBarTheme = Theme.of(context).bottomNavigationBarTheme;
    final selectedColorFilter = ColorFilter.mode(
      bottomNavBarTheme.selectedItemColor!,
      BlendMode.srcIn,
    );
    final unselectedColorFilter = ColorFilter.mode(
      bottomNavBarTheme.unselectedItemColor!,
      BlendMode.srcIn,
    );
    return BottomNavigationBar(
      onTap: presenter.jumpToPage,
      currentIndex: presenter.currentPage,
      items: [
        BottomNavigationBarItem(
          // Home
          label: 'Home',
          icon: SvgPicture.asset(
            _homeSvg,
            colorFilter: unselectedColorFilter,
            height: _iconSize,
            width: _iconSize,
          ),
          activeIcon: SvgPicture.asset(
            _homeSvg,
            colorFilter: selectedColorFilter,
            height: _iconSize,
            width: _iconSize,
          ),
        ),
        // Vaults
        BottomNavigationBarItem(
          label: 'Safe',
          icon: SvgPicture.asset(
            _vaultsSvg,
            colorFilter: unselectedColorFilter,
            height: _iconSize,
            width: _iconSize,
          ),
          activeIcon: SvgPicture.asset(
            _vaultsSvg,
            colorFilter: selectedColorFilter,
            height: _iconSize,
            width: _iconSize,
          ),
        ),
        // Shards
        BottomNavigationBarItem(
          label: 'Shards',
          icon: SvgPicture.asset(
            _shardsSvg,
            colorFilter: unselectedColorFilter,
            height: _iconSize,
            width: _iconSize,
          ),
          activeIcon: SvgPicture.asset(
            _shardsSvg,
            colorFilter: selectedColorFilter,
            height: _iconSize,
            width: _iconSize,
          ),
        ),
        // Requests
        const BottomNavigationBarItem(
          label: 'Requests',
          icon: RequestsIcon(
            isSelected: false,
            iconSize: _iconSize,
          ),
          activeIcon: RequestsIcon(
            isSelected: true,
            iconSize: _iconSize,
          ),
        ),
      ],
    );
  }
}
