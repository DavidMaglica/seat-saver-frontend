import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

class Animations {
  static final Map<String, AnimationInfo> landingAnimations = {
    'logoOnLoad': _fadeBounceOut,
    'textOnLoad': _fadeUpDelayed,
    'buttonOnLoad': _fadeScaleUpDelayed,
  };

  static final AnimationInfo _fadeBounceOut = AnimationInfo(
    trigger: AnimationTrigger.onPageLoad,
    effectsBuilder: () => [
      delayedVisibility,
      FadeEffect(
        curve: Curves.easeInOut,
        delay: 500.0.ms,
        duration: 500.0.ms,
        begin: 0.0,
        end: 1.0,
      ),
      ScaleEffect(
        curve: Curves.bounceOut,
        delay: 500.0.ms,
        duration: 500.0.ms,
        begin: const Offset(0.6, 0.6),
        end: const Offset(1.0, 1.0),
      ),
    ],
  );

  static final AnimationInfo _fadeUpDelayed = AnimationInfo(
    trigger: AnimationTrigger.onPageLoad,
    effectsBuilder: () => [
      Animations.delayedVisibility,
      FadeEffect(
        curve: Curves.easeInOut,
        delay: 550.0.ms,
        duration: 600.0.ms,
        begin: 0.0,
        end: 1.0,
      ),
      MoveEffect(
        curve: Curves.easeInOut,
        delay: 550.0.ms,
        duration: 600.0.ms,
        begin: const Offset(0.0, 30.0),
        end: const Offset(0.0, 0.0),
      ),
    ],
  );

  static final AnimationInfo _fadeScaleUpDelayed = AnimationInfo(
    trigger: AnimationTrigger.onPageLoad,
    effectsBuilder: () => [
      delayedVisibility,
      FadeEffect(
        curve: Curves.easeInOut,
        delay: 600.0.ms,
        duration: 800.0.ms,
        begin: 0.0,
        end: 1.0,
      ),
      ScaleEffect(
        curve: Curves.easeInOutQuint,
        delay: 600.0.ms,
        duration: 800.0.ms,
        begin: const Offset(0.6, 0.6),
        end: const Offset(1.0, 1.0),
      ),
    ],
  );

  static final Map<String, AnimationInfo> authenticationAnimations = {
    'authOnLoad': _fadeUpPop,
    'tabOnLoad': _fadeUpShortDelayed,
  };

  static final AnimationInfo _fadeUpPop = AnimationInfo(
    trigger: AnimationTrigger.onPageLoad,
    effectsBuilder: () => [
      instantVisibility,
      FadeEffect(
        curve: Curves.easeInOut,
        delay: 0.0.ms,
        duration: 400.0.ms,
        begin: 0.0,
        end: 1.0,
      ),
      MoveEffect(
        curve: Curves.easeInOut,
        delay: 0.0.ms,
        duration: 400.0.ms,
        begin: const Offset(0.0, 80.0),
        end: const Offset(0.0, 0.0),
      ),
      ScaleEffect(
        curve: Curves.easeInOut,
        delay: 150.0.ms,
        duration: 400.0.ms,
        begin: const Offset(0.8, 0.8),
        end: const Offset(1.0, 1.0),
      ),
    ],
  );

  static final AnimationInfo _fadeUpShortDelayed = AnimationInfo(
    trigger: AnimationTrigger.onPageLoad,
    effectsBuilder: () => [
      quickVisibility,
      FadeEffect(
        curve: Curves.easeInOut,
        delay: 300.0.ms,
        duration: 400.0.ms,
        begin: 0.0,
        end: 1.0,
      ),
      MoveEffect(
        curve: Curves.easeInOut,
        delay: 300.0.ms,
        duration: 400.0.ms,
        begin: const Offset(0.0, 20.0),
        end: const Offset(0.0, 0.0),
      ),
    ],
  );

  static Map<String, AnimationInfo> homepageAnimations = {
    'titleRowOnLoad': _fadeUpFast,
    'circularStatsOnLoad': _fadeMoveUpDelayed,
    'tableOnLoad': _fadeMoveUpDelayed,
    'performanceOnLoad': _fadeMoveUpDelayed,
  };

  static Map<String, AnimationInfo> venuesAnimations = {
    'gridOnLoad': _fadeRight,
  };

  static final AnimationInfo _fadeRight = AnimationInfo(
    trigger: AnimationTrigger.onPageLoad,
    effectsBuilder: () => [
      FadeEffect(
        curve: Curves.easeInOut,
        delay: 300.0.ms,
        duration: 600.0.ms,
        begin: 0.0,
        end: 1.0,
      ),
      MoveEffect(
        curve: Curves.easeInOut,
        delay: 400.0.ms,
        duration: 300.0.ms,
        begin: const Offset(100.0, 0.0),
        end: const Offset(0.0, 0.0),
      ),
    ],
  );

  static Map<String, AnimationInfo> venuePageAnimations = {
    'headerImageOnLoad': _fadeUpScale,
    'fadeInOnLoad': _fadeQuick,
    'fadeMoveUpOnLoad': _fadeUp,
  };

  static final AnimationInfo _fadeUpScale = AnimationInfo(
    trigger: AnimationTrigger.onPageLoad,
    effectsBuilder: () => [
      FadeEffect(
        curve: Curves.easeInOut,
        delay: 0.0.ms,
        duration: 600.0.ms,
        begin: 0.0,
        end: 1.0,
      ),
      MoveEffect(
        curve: Curves.easeInOut,
        delay: 0.0.ms,
        duration: 600.0.ms,
        begin: const Offset(0.0, 40.0),
        end: const Offset(0.0, 0.0),
      ),
      ScaleEffect(
        curve: Curves.easeInOut,
        delay: 0.0.ms,
        duration: 600.0.ms,
        begin: const Offset(0.6, 0.6),
        end: const Offset(1.0, 1.0),
      ),
    ],
  );

  static final AnimationInfo _fadeQuick = AnimationInfo(
    trigger: AnimationTrigger.onPageLoad,
    effectsBuilder: () => [
      VisibilityEffect(duration: 100.ms),
      FadeEffect(
        curve: Curves.easeInOut,
        delay: 100.0.ms,
        duration: 600.0.ms,
        begin: 0.0,
        end: 1.0,
      ),
    ],
  );

  static final AnimationInfo _fadeUp = AnimationInfo(
    trigger: AnimationTrigger.onPageLoad,
    effectsBuilder: () => [
      FadeEffect(
        curve: Curves.easeInOut,
        delay: 0.0.ms,
        duration: 600.0.ms,
        begin: 0.0,
        end: 1.0,
      ),
      MoveEffect(
        curve: Curves.easeInOut,
        delay: 0.0.ms,
        duration: 600.0.ms,
        begin: const Offset(0.0, 80.0),
        end: const Offset(0.0, 0.0),
      ),
    ],
  );

  static Map<String, AnimationInfo> accountAnimations = {
    'accountDetailsOnLoad': _fadeMoveUpDelayed,
    'actionsOnLoad': _fadeUpSlowDelayed,
    'buttonOnLoad': _fadeMoveUpDelayed,
  };

  static final AnimationInfo _fadeUpSlowDelayed = AnimationInfo(
    trigger: AnimationTrigger.onPageLoad,
    effectsBuilder: () => [
      VisibilityEffect(duration: 300.ms),
      FadeEffect(
        curve: Curves.easeInOut,
        delay: 300.0.ms,
        duration: 600.0.ms,
        begin: 0.0,
        end: 1.0,
      ),
      MoveEffect(
        curve: Curves.easeInOut,
        delay: 400.0.ms,
        duration: 300.0.ms,
        begin: const Offset(0.0, 100.0),
        end: const Offset(0.0, 0.0),
      ),
    ],
  );

  static Map<String, AnimationInfo> reservationsAnimations = {
    'reservationsOnLoad': _fadeInUp,
  };

  static final AnimationInfo _fadeInUp = AnimationInfo(
    trigger: AnimationTrigger.onPageLoad,
    effectsBuilder: () => [
      instantVisibility,
      FadeEffect(
        curve: Curves.easeInOut,
        delay: 300.0.ms,
        duration: 600.0.ms,
        begin: 0.0,
        end: 1.0,
      ),
      MoveEffect(
        curve: Curves.easeInOut,
        delay: 400.0.ms,
        duration: 300.0.ms,
        begin: const Offset(0.0, 100.0),
        end: const Offset(0.0, 0.0),
      ),
    ],
  );

  static Map<String, AnimationInfo> utilityPagesAnimations = {
    'titleRowOnLoad': _fadeUpFast,
    'gridOnLoad': _fadeMoveUpDelayed,
  };

  static Map<String, AnimationInfo> modalAnimations = {
    'modalOnLoad': _fadeUpModal,
  };

  static final AnimationInfo _fadeUpModal = AnimationInfo(
    trigger: AnimationTrigger.onPageLoad,
    effectsBuilder: () => [
      instantVisibility,
      FadeEffect(
        curve: Curves.easeInOut,
        delay: 300.0.ms,
        duration: 400.0.ms,
        begin: 0.0,
        end: 1.0,
      ),
      MoveEffect(
        curve: Curves.easeInOut,
        delay: 300.0.ms,
        duration: 400.0.ms,
        begin: const Offset(0.0, 100.0),
        end: const Offset(0.0, 0.0),
      ),
    ],
  );

  static VisibilityEffect instantVisibility = VisibilityEffect(duration: 1.ms);

  static VisibilityEffect quickVisibility = VisibilityEffect(duration: 300.ms);

  static VisibilityEffect delayedVisibility = VisibilityEffect(
    duration: 500.ms,
  );

  static final AnimationInfo _fadeMoveUpDelayed = AnimationInfo(
    trigger: AnimationTrigger.onPageLoad,
    effectsBuilder: () => [
      FadeEffect(
        curve: Curves.easeInOut,
        delay: 300.0.ms,
        duration: 600.0.ms,
        begin: 0.0,
        end: 1.0,
      ),
      MoveEffect(
        curve: Curves.easeInOut,
        delay: 400.0.ms,
        duration: 300.0.ms,
        begin: const Offset(0.0, 100.0),
        end: const Offset(0.0, 0.0),
      ),
    ],
  );

  static final AnimationInfo _fadeUpFast = AnimationInfo(
    trigger: AnimationTrigger.onPageLoad,
    effectsBuilder: () => [
      FadeEffect(
        curve: Curves.easeInOut,
        delay: 0.0.ms,
        duration: 600.0.ms,
        begin: 0.0,
        end: 1.0,
      ),
      MoveEffect(
        curve: Curves.easeInOut,
        delay: 0.0.ms,
        duration: 300.0.ms,
        begin: const Offset(0.0, 100.0),
        end: const Offset(0.0, 0.0),
      ),
    ],
  );
}
