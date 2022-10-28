import '/src/core/widgets/common.dart';
import '/src/core/theme/theme.dart';
import '/src/core/widgets/icon_of.dart';
import '/src/core/model/core_model.dart';
import 'online_status_widget.dart';

class GuardianTileWidget extends StatelessWidget {
  final PeerId guardian;
  final bool? isSuccess;
  final bool isWaiting;
  final bool checkStatus;

  const GuardianTileWidget({
    super.key,
    required this.guardian,
    this.isSuccess,
    this.isWaiting = false,
    this.checkStatus = false,
  });

  @override
  Widget build(BuildContext context) => ListTile(
        visualDensity: checkStatus
            ? const VisualDensity(vertical: VisualDensity.maximumDensity)
            : null,
        leading: checkStatus
            ? Column(children: [
                _buildLeading(),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: OnlineStatusWidget(peerId: guardian),
                ),
              ])
            : _buildLeading(),
        title: RichText(
          maxLines: 1,
          text: TextSpan(
            style: textStyleSourceSansPro614.copyWith(height: 1.5),
            children: buildTextWithId(
              id: guardian,
              style: TextStyle(
                color: guardian.token.isEmpty
                    ? clRed
                    : Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ),
        subtitle: Text(
          guardian.toHexShort(),
          maxLines: 1,
          style: textStyleSourceSansPro414Purple,
        ),
        trailing: isWaiting
            ? Container(
                alignment: Alignment.centerRight,
                margin: checkStatus ? paddingTop20 : null,
                height: 20,
                width: 20,
                child: const CircularProgressIndicator.adaptive(strokeWidth: 2),
              )
            : null,
      );

  Widget _buildLeading() => IconOf.shield(
        color: clWhite,
        bgColor: isSuccess == null
            ? null
            : isSuccess == true
                ? clGreen
                : clRed,
      );
}
