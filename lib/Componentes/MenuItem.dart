import 'package:flutter/material.dart';

import 'dart:math' as math;

class MenuItem extends StatefulWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const MenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    super.key,
  });

  @override
  _MenuItemState createState() => _MenuItemState();
}

class _MenuItemState extends State<MenuItem> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() {
        isHovered = true;
      }),
      onExit: (_) => setState(() {
        isHovered = false;
      }),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          color: isHovered ? Colors.grey[800] : Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(
            children: [
              Icon(
                widget.icon,
                color: isHovered ? Colors.blue : Colors.white,
              ),
              const SizedBox(width: 10),
              Text(
                widget.title,
                style: TextStyle(
                  color: isHovered ? Colors.blue : Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuItemArrow extends StatefulWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool expanded; // Valor que controla a rotação

  const MenuItemArrow({
    required this.icon,
    required this.title,
    required this.onTap,
    required this.expanded, // Recebe o valor de controle
    super.key,
  });

  @override
  _MenuItemArrowState createState() => _MenuItemArrowState();
}

class _MenuItemArrowState extends State<MenuItemArrow> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() {
        isHovered = true;
      }),
      onExit: (_) => setState(() {
        isHovered = false;
      }),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          color: isHovered ? Colors.grey[800] : Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(
            children: [
              Icon(
                widget.icon,
                color: isHovered ? Colors.blue : Colors.white,
              ),
              const SizedBox(width: 10),
              Text(
                widget.title,
                style: TextStyle(
                  color: isHovered ? Colors.blue : Colors.white,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 300),
                tween: Tween<double>(
                  begin: 0,
                  end: widget.expanded ? 90 : 0, // Controla o ângulo de rotação
                ),
                builder: (context, angle, child) {
                  return Transform.rotate(
                    angle: angle * math.pi / 180, // Converte para radianos
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: isHovered ? Colors.blue : Colors.white,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HoverTextButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;

  const HoverTextButton({
    required this.text,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  _HoverTextButtonState createState() => _HoverTextButtonState();
}

class _HoverTextButtonState extends State<HoverTextButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: TextButton(
        onPressed: widget.onPressed,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(8.0),
          foregroundColor: isHovered ? Colors.blue : Colors.white,
        ),
        child: Text(
          widget.text,
          style: TextStyle(
            color: isHovered ? Colors.blue : Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

class CustomMenuItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool isHovered;

  const CustomMenuItem({
    Key? key,
    required this.title,
    required this.icon,
    required this.onTap,
    required this.isHovered,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: isHovered ? Colors.grey[800] : Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          children: [
            Icon(icon, color: isHovered ? Colors.blue : Colors.white),
            const SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                color: isHovered ? Colors.blue : Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomIconButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool isHovered;

  const CustomIconButton({
    Key? key,
    required this.title,
    required this.icon,
    required this.onTap,
    required this.isHovered,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => onTap(),
      onExit: (_) => onTap(),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(icon),
        color: isHovered ? Colors.blue : Colors.white,
      ),
    );
  }
}
