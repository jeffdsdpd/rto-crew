import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/crew_store.dart';
import 'crew_home_screen.dart';

const _navy = Color(0xFF032C44);
const _aqua = Color(0xFF22D7D8);
const _reference = 'design/Rock the Ocean Crew Welcome Screen.png';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key, required this.store});
  final CrewStore store;

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
    value: SystemUiOverlayStyle.light,
    child: Scaffold(
      backgroundColor: _navy,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final textScale = MediaQuery.textScalerOf(context).scale(14) / 14;
            // Keep accessible text and full touch targets on small screens too.
            final height = math.max(
              constraints.maxHeight,
              660.0 * math.pow(math.max(1.0, textScale), 2),
            );
            final footerHeight = math.max(130.0, height * .17);
            // Preserve the artwork's source aspect ratio and reserve enough
            // room for readable copy, touch targets, and the complete footer.
            final heroHeight = math.min(
              constraints.maxWidth * 690 / 770,
              height - footerHeight - 340 * math.max(1.0, textScale),
            );
            return SingleChildScrollView(
              physics: height <= constraints.maxHeight
                  ? const NeverScrollableScrollPhysics()
                  : null,
              child: SizedBox(
                height: height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: heroHeight, child: const _Hero()),
                    SizedBox(
                      height: height - heroHeight - footerHeight,
                      child: _MainContent(
                        onStaff: () => _enter(context, true),
                        onVolunteer: () => _enter(context, false),
                      ),
                    ),
                    Transform.translate(
                      offset: const Offset(0, -30),
                      child: SizedBox(
                        height: footerHeight,
                        child: const _OceanFooter(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    ),
  );

  void _enter(BuildContext context, bool staff) => Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => CrewHomeScreen(store: store, staff: staff),
    ),
  );
}

// Display only the reference's artwork, excluding its phone frame and status bar.
// Fractional source coordinates keep the original photography and brand lettering.
class _ReferenceRegion extends StatelessWidget {
  const _ReferenceRegion({required this.region});
  final Rect region;

  @override
  Widget build(BuildContext context) => ClipRect(
    child: LayoutBuilder(
      builder: (context, constraints) => OverflowBox(
        alignment: Alignment.topLeft,
        maxWidth: double.infinity,
        maxHeight: double.infinity,
        child: Transform.translate(
          offset: Offset(
            -region.left * constraints.maxWidth / region.width,
            -region.top * constraints.maxHeight / region.height,
          ),
          child: Image.asset(
            _reference,
            width: constraints.maxWidth / region.width,
            height: constraints.maxHeight / region.height,
            fit: BoxFit.fill,
            excludeFromSemantics: true,
          ),
        ),
      ),
    ),
  );
}

class _Hero extends StatelessWidget {
  const _Hero();

  @override
  Widget build(BuildContext context) => Semantics(
    image: true,
    label: "Rock The Ocean. RTO CREW. Rock The Ocean's Conservation Crew.",
    child: const Stack(
      fit: StackFit.expand,
      children: [
        Center(
          child: AspectRatio(
            aspectRatio: 770 / 690,
            child: _ReferenceRegion(
              region: Rect.fromLTRB(
                40 / 850,
                130 / 1850,
                810 / 850,
                820 / 1850,
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: -1,
          height: 26,
          child: CustomPaint(painter: _WavePainter()),
        ),
      ],
    ),
  );
}

class _MainContent extends StatelessWidget {
  const _MainContent({required this.onStaff, required this.onVolunteer});
  final VoidCallback onStaff;
  final VoidCallback onVolunteer;

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: Colors.white,
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _Statement('GOOD PEOPLE.'),
              const _Statement('REAL IMPACT.'),
              const SizedBox(height: 10),
              const Text(
                'Ready to make some waves?',
                style: TextStyle(
                  fontSize: 16,
                  height: 1.2,
                  fontWeight: FontWeight.w800,
                  color: _navy,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Connect with your crew, see what needs to be done, and help make Tortuga a force for ocean conservation.',
                style: TextStyle(fontSize: 13.5, height: 1.3, color: _navy),
              ),
              const SizedBox(height: 12),
              _EntryButton(
                label: 'RTO STAFF',
                icon: Icons.groups,
                background: _navy,
                foreground: Colors.white,
                onPressed: onStaff,
              ),
              const SizedBox(height: 6),
              _EntryButton(
                label: 'VOLUNTEER',
                icon: Icons.volunteer_activism_outlined,
                background: _aqua,
                foreground: _navy,
                onPressed: onVolunteer,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _Statement extends StatelessWidget {
  const _Statement(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Semantics(
    header: true,
    child: FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 30,
          height: 1.02,
          letterSpacing: -1,
          fontWeight: FontWeight.w900,
          color: _navy,
        ),
      ),
    ),
  );
}

class _EntryButton extends StatelessWidget {
  const _EntryButton({
    required this.label,
    required this.icon,
    required this.background,
    required this.foreground,
    required this.onPressed,
  });
  final String label;
  final IconData icon;
  final Color background;
  final Color foreground;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => FilledButton(
    style: FilledButton.styleFrom(
      backgroundColor: background,
      foregroundColor: foreground,
      minimumSize: const Size.fromHeight(54),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    onPressed: onPressed,
    child: Row(
      children: [
        Icon(icon, size: 25),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w900,
              height: 1.1,
              letterSpacing: .4,
            ),
          ),
        ),
        const SizedBox(width: 8),
        const Icon(Icons.arrow_forward_rounded, size: 23),
      ],
    ),
  );
}

class _OceanFooter extends StatelessWidget {
  const _OceanFooter();

  @override
  Widget build(BuildContext context) => Stack(
    fit: StackFit.expand,
    children: [
      // The right side of the reference contains water and the turtle, no text.
      const _ReferenceRegion(
        region: Rect.fromLTRB(590 / 850, 1575 / 1850, 775 / 850, 1740 / 1850),
      ),
      const ColoredBox(color: Color(0x33032C44)),
      const Positioned(
        top: -1,
        left: 0,
        right: 0,
        height: 20,
        child: RotatedBox(
          quarterTurns: 2,
          child: CustomPaint(painter: _WavePainter()),
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                "WE'RE NOT TRYING TO SAVE\nTHE WHOLE WORLD...",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.15,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
            const FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'JUST ¾ OF IT.',
                style: TextStyle(
                  fontSize: 25,
                  height: 1.2,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w900,
                  color: _aqua,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Container(width: 65, height: 2, color: _aqua),
          ],
        ),
      ),
    ],
  );
}

class _WavePainter extends CustomPainter {
  const _WavePainter();

  @override
  void paint(Canvas canvas, Size size) {
    for (final (offset, color) in [
      (0.0, _aqua),
      (4.0, _navy),
      (7.0, Colors.white),
    ]) {
      final path = Path()
        ..moveTo(0, size.height * .35 + offset)
        ..cubicTo(
          size.width * .35,
          -size.height * .4 + offset,
          size.width * .65,
          size.height * .9 + offset,
          size.width,
          size.height * .4 + offset,
        )
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height)
        ..close();
      canvas.drawPath(path, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(_WavePainter oldDelegate) => false;
}
