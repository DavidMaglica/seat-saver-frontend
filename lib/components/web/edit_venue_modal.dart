//
// import 'package:TableReserver/models/web/edit_venue_model.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:flutterflow_ui/flutterflow_ui.dart';
//
// class EditVenueWidget extends StatefulWidget {
//   const EditVenueWidget({
//     super.key,
//     String? isFeature,
//   }) : this.isFeature = isFeature ?? 'false';
//
//   final String isFeature;
//
//   @override
//   State<EditVenueWidget> createState() => _EditVenueWidgetState();
// }
//
// class _EditVenueWidgetState extends State<EditVenueWidget>
//     with TickerProviderStateMixin {
//   late EditVenueModel _model;
//
//   final animationsMap = <String, AnimationInfo>{};
//
//   @override
//   void setState(VoidCallback callback) {
//     super.setState(callback);
//     _model.onUpdate();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _model = createModel(context, () => EditVenueModel());
//
//     _model.nameTextController1 ??= TextEditingController();
//     _model.nameFocusNode1 ??= FocusNode();
//
//     _model.locationTextController ??= TextEditingController();
//     _model.locationFocusNode ??= FocusNode();
//
//     _model.maxCapacityTextController ??= TextEditingController();
//     _model.maxCapacityFocusNode ??= FocusNode();
//
//     _model.nameTextController2 ??= TextEditingController();
//     _model.nameFocusNode2 ??= FocusNode();
//
//     _model.nameTextController3 ??= TextEditingController();
//     _model.nameFocusNode3 ??= FocusNode();
//
//     animationsMap.addAll({
//       'containerOnPageLoadAnimation': AnimationInfo(
//         trigger: AnimationTrigger.onPageLoad,
//         effects: [
//           VisibilityEffect(duration: 300.ms),
//           FadeEffect(
//             curve: Curves.easeInOut,
//             delay: 300.0.ms,
//             duration: 400.0.ms,
//             begin: 0.0,
//             end: 1.0,
//           ),
//           MoveEffect(
//             curve: Curves.easeInOut,
//             delay: 300.0.ms,
//             duration: 400.0.ms,
//             begin: const Offset(0.0, 100.0),
//             end: const Offset(0.0, 0.0),
//           ),
//         ],
//       ),
//     });
//     setupAnimations(
//       animationsMap.values.where((anim) =>
//       anim.trigger == AnimationTrigger.onActionTrigger ||
//           !anim.applyInitialState),
//       this,
//     );
//   }
//
//   @override
//   void dispose() {
//     _model.maybeDispose();
//
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       height: double.infinity,
//       decoration: const BoxDecoration(
//         color: Color(0x7FFFFBF4),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.max,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Padding(
//             padding: const EdgeInsetsDirectional.fromSTEB(16, 2, 16, 16),
//             child: Container(
//               width: double.infinity,
//               constraints: const BoxConstraints(
//                 maxWidth: 670,
//               ),
//               decoration: BoxDecoration(
//                 color: FlutterFlowTheme.of(context).secondaryBackground,
//                 boxShadow: const [
//                   BoxShadow(
//                     blurRadius: 12,
//                     color: Color(0x1E000000),
//                     offset: Offset(
//                       0,
//                       5,
//                     ),
//                   )
//                 ],
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.max,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsetsDirectional.fromSTEB(24, 16, 0, 0),
//                     child: Text(
//                       'Edit Venue',
//                       style:
//                       FlutterFlowTheme.of(context).headlineMedium.override(
//                         font: GoogleFonts.oswald(
//                           fontWeight: FontWeight.normal,
//                           fontStyle: FlutterFlowTheme.of(context)
//                               .headlineMedium
//                               .fontStyle,
//                         ),
//                         letterSpacing: 0.0,
//                         fontWeight: FontWeight.normal,
//                         fontStyle: FlutterFlowTheme.of(context)
//                             .headlineMedium
//                             .fontStyle,
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.max,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
//                           child: Row(
//                             mainAxisSize: MainAxisSize.max,
//                             children: [
//                               Expanded(
//                                 child: TextFormField(
//                                   controller: _model.nameTextController1,
//                                   focusNode: _model.nameFocusNode1,
//                                   autofocus: false,
//                                   obscureText: false,
//                                   decoration: InputDecoration(
//                                     labelText: 'Venue Name',
//                                     labelStyle: FlutterFlowTheme.of(context)
//                                         .labelMedium
//                                         .override(
//                                       font: GoogleFonts.roboto(
//                                         fontWeight:
//                                         FlutterFlowTheme.of(context)
//                                             .labelMedium
//                                             .fontWeight,
//                                         fontStyle:
//                                         FlutterFlowTheme.of(context)
//                                             .labelMedium
//                                             .fontStyle,
//                                       ),
//                                       letterSpacing: 0.0,
//                                       fontWeight:
//                                       FlutterFlowTheme.of(context)
//                                           .labelMedium
//                                           .fontWeight,
//                                       fontStyle:
//                                       FlutterFlowTheme.of(context)
//                                           .labelMedium
//                                           .fontStyle,
//                                     ),
//                                     alignLabelWithHint: false,
//                                     hintStyle: FlutterFlowTheme.of(context)
//                                         .labelMedium
//                                         .override(
//                                       font: GoogleFonts.roboto(
//                                         fontWeight:
//                                         FlutterFlowTheme.of(context)
//                                             .labelMedium
//                                             .fontWeight,
//                                         fontStyle:
//                                         FlutterFlowTheme.of(context)
//                                             .labelMedium
//                                             .fontStyle,
//                                       ),
//                                       letterSpacing: 0.0,
//                                       fontWeight:
//                                       FlutterFlowTheme.of(context)
//                                           .labelMedium
//                                           .fontWeight,
//                                       fontStyle:
//                                       FlutterFlowTheme.of(context)
//                                           .labelMedium
//                                           .fontStyle,
//                                     ),
//                                     enabledBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(
//                                         color: FlutterFlowTheme.of(context)
//                                             .primaryText,
//                                         width: 1,
//                                       ),
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                     focusedBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(
//                                         color: FlutterFlowTheme.of(context)
//                                             .primary,
//                                         width: 1,
//                                       ),
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                     errorBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(
//                                         color:
//                                         FlutterFlowTheme.of(context).error,
//                                         width: 1,
//                                       ),
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                     focusedErrorBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(
//                                         color:
//                                         FlutterFlowTheme.of(context).error,
//                                         width: 1,
//                                       ),
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                     filled: true,
//                                     fillColor: FlutterFlowTheme.of(context)
//                                         .secondaryBackground,
//                                     contentPadding:
//                                     const EdgeInsetsDirectional.fromSTEB(
//                                         20, 24, 20, 24),
//                                   ),
//                                   style: FlutterFlowTheme.of(context)
//                                       .bodyMedium
//                                       .override(
//                                     font: GoogleFonts.roboto(
//                                       fontWeight:
//                                       FlutterFlowTheme.of(context)
//                                           .bodyMedium
//                                           .fontWeight,
//                                       fontStyle:
//                                       FlutterFlowTheme.of(context)
//                                           .bodyMedium
//                                           .fontStyle,
//                                     ),
//                                     letterSpacing: 0.0,
//                                     fontWeight: FlutterFlowTheme.of(context)
//                                         .bodyMedium
//                                         .fontWeight,
//                                     fontStyle: FlutterFlowTheme.of(context)
//                                         .bodyMedium
//                                         .fontStyle,
//                                   ),
//                                   cursorColor:
//                                   FlutterFlowTheme.of(context).primary,
//                                   validator: _model.nameTextController1Validator
//                                       .asValidator(context),
//                                 ),
//                               ),
//                               Expanded(
//                                 child: TextFormField(
//                                   controller: _model.locationTextController,
//                                   focusNode: _model.locationFocusNode,
//                                   autofocus: false,
//                                   obscureText: false,
//                                   decoration: InputDecoration(
//                                     labelText: 'Venue Location (Address)',
//                                     labelStyle: FlutterFlowTheme.of(context)
//                                         .labelMedium
//                                         .override(
//                                       font: GoogleFonts.roboto(
//                                         fontWeight:
//                                         FlutterFlowTheme.of(context)
//                                             .labelMedium
//                                             .fontWeight,
//                                         fontStyle:
//                                         FlutterFlowTheme.of(context)
//                                             .labelMedium
//                                             .fontStyle,
//                                       ),
//                                       letterSpacing: 0.0,
//                                       fontWeight:
//                                       FlutterFlowTheme.of(context)
//                                           .labelMedium
//                                           .fontWeight,
//                                       fontStyle:
//                                       FlutterFlowTheme.of(context)
//                                           .labelMedium
//                                           .fontStyle,
//                                     ),
//                                     alignLabelWithHint: false,
//                                     hintStyle: FlutterFlowTheme.of(context)
//                                         .labelMedium
//                                         .override(
//                                       font: GoogleFonts.roboto(
//                                         fontWeight:
//                                         FlutterFlowTheme.of(context)
//                                             .labelMedium
//                                             .fontWeight,
//                                         fontStyle:
//                                         FlutterFlowTheme.of(context)
//                                             .labelMedium
//                                             .fontStyle,
//                                       ),
//                                       letterSpacing: 0.0,
//                                       fontWeight:
//                                       FlutterFlowTheme.of(context)
//                                           .labelMedium
//                                           .fontWeight,
//                                       fontStyle:
//                                       FlutterFlowTheme.of(context)
//                                           .labelMedium
//                                           .fontStyle,
//                                     ),
//                                     enabledBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(
//                                         color: FlutterFlowTheme.of(context)
//                                             .primaryText,
//                                         width: 1,
//                                       ),
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                     focusedBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(
//                                         color: FlutterFlowTheme.of(context)
//                                             .primary,
//                                         width: 1,
//                                       ),
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                     errorBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(
//                                         color:
//                                         FlutterFlowTheme.of(context).error,
//                                         width: 1,
//                                       ),
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                     focusedErrorBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(
//                                         color:
//                                         FlutterFlowTheme.of(context).error,
//                                         width: 1,
//                                       ),
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                     filled: true,
//                                     fillColor: FlutterFlowTheme.of(context)
//                                         .secondaryBackground,
//                                     contentPadding:
//                                     const EdgeInsetsDirectional.fromSTEB(
//                                         20, 24, 20, 24),
//                                   ),
//                                   style: FlutterFlowTheme.of(context)
//                                       .bodyMedium
//                                       .override(
//                                     font: GoogleFonts.roboto(
//                                       fontWeight:
//                                       FlutterFlowTheme.of(context)
//                                           .bodyMedium
//                                           .fontWeight,
//                                       fontStyle:
//                                       FlutterFlowTheme.of(context)
//                                           .bodyMedium
//                                           .fontStyle,
//                                     ),
//                                     letterSpacing: 0.0,
//                                     fontWeight: FlutterFlowTheme.of(context)
//                                         .bodyMedium
//                                         .fontWeight,
//                                     fontStyle: FlutterFlowTheme.of(context)
//                                         .bodyMedium
//                                         .fontStyle,
//                                   ),
//                                   cursorColor:
//                                   FlutterFlowTheme.of(context).primary,
//                                   validator: _model
//                                       .locationTextControllerValidator
//                                       .asValidator(context),
//                                 ),
//                               ),
//                             ].divide(const SizedBox(width: 32)),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
//                           child: Row(
//                             mainAxisSize: MainAxisSize.max,
//                             children: [
//                               Expanded(
//                                 child: TextFormField(
//                                   controller: _model.maxCapacityTextController,
//                                   focusNode: _model.maxCapacityFocusNode,
//                                   autofocus: false,
//                                   obscureText: false,
//                                   decoration: InputDecoration(
//                                     labelText: 'Maximum Capacity',
//                                     labelStyle: FlutterFlowTheme.of(context)
//                                         .labelMedium
//                                         .override(
//                                       font: GoogleFonts.roboto(
//                                         fontWeight:
//                                         FlutterFlowTheme.of(context)
//                                             .labelMedium
//                                             .fontWeight,
//                                         fontStyle:
//                                         FlutterFlowTheme.of(context)
//                                             .labelMedium
//                                             .fontStyle,
//                                       ),
//                                       letterSpacing: 0.0,
//                                       fontWeight:
//                                       FlutterFlowTheme.of(context)
//                                           .labelMedium
//                                           .fontWeight,
//                                       fontStyle:
//                                       FlutterFlowTheme.of(context)
//                                           .labelMedium
//                                           .fontStyle,
//                                     ),
//                                     alignLabelWithHint: false,
//                                     hintStyle: FlutterFlowTheme.of(context)
//                                         .labelMedium
//                                         .override(
//                                       font: GoogleFonts.roboto(
//                                         fontWeight:
//                                         FlutterFlowTheme.of(context)
//                                             .labelMedium
//                                             .fontWeight,
//                                         fontStyle:
//                                         FlutterFlowTheme.of(context)
//                                             .labelMedium
//                                             .fontStyle,
//                                       ),
//                                       letterSpacing: 0.0,
//                                       fontWeight:
//                                       FlutterFlowTheme.of(context)
//                                           .labelMedium
//                                           .fontWeight,
//                                       fontStyle:
//                                       FlutterFlowTheme.of(context)
//                                           .labelMedium
//                                           .fontStyle,
//                                     ),
//                                     enabledBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(
//                                         color: FlutterFlowTheme.of(context)
//                                             .primaryText,
//                                         width: 1,
//                                       ),
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                     focusedBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(
//                                         color: FlutterFlowTheme.of(context)
//                                             .primary,
//                                         width: 1,
//                                       ),
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                     errorBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(
//                                         color:
//                                         FlutterFlowTheme.of(context).error,
//                                         width: 1,
//                                       ),
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                     focusedErrorBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(
//                                         color:
//                                         FlutterFlowTheme.of(context).error,
//                                         width: 1,
//                                       ),
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                     filled: true,
//                                     fillColor: FlutterFlowTheme.of(context)
//                                         .secondaryBackground,
//                                     contentPadding:
//                                     const EdgeInsetsDirectional.fromSTEB(
//                                         20, 24, 20, 24),
//                                   ),
//                                   style: FlutterFlowTheme.of(context)
//                                       .bodyMedium
//                                       .override(
//                                     font: GoogleFonts.roboto(
//                                       fontWeight:
//                                       FlutterFlowTheme.of(context)
//                                           .bodyMedium
//                                           .fontWeight,
//                                       fontStyle:
//                                       FlutterFlowTheme.of(context)
//                                           .bodyMedium
//                                           .fontStyle,
//                                     ),
//                                     letterSpacing: 0.0,
//                                     fontWeight: FlutterFlowTheme.of(context)
//                                         .bodyMedium
//                                         .fontWeight,
//                                     fontStyle: FlutterFlowTheme.of(context)
//                                         .bodyMedium
//                                         .fontStyle,
//                                   ),
//                                   keyboardType: TextInputType.number,
//                                   cursorColor:
//                                   FlutterFlowTheme.of(context).primary,
//                                   validator: _model
//                                       .maxCapacityTextControllerValidator
//                                       .asValidator(context),
//                                 ),
//                               ),
//                               FlutterFlowDropDown<String>(
//                                 controller: _model.dropDownValueController ??=
//                                     FormFieldController<String>(null),
//                                 options: const ['Option 1', 'Option 2'],
//                                 onChanged: (val) => safeSetState(
//                                         () => _model.dropDownValue = val),
//                                 width: 303,
//                                 height: 57,
//                                 searchHintTextStyle: FlutterFlowTheme.of(
//                                     context)
//                                     .labelMedium
//                                     .override(
//                                   font: GoogleFonts.roboto(
//                                     fontWeight: FlutterFlowTheme.of(context)
//                                         .labelMedium
//                                         .fontWeight,
//                                     fontStyle: FlutterFlowTheme.of(context)
//                                         .labelMedium
//                                         .fontStyle,
//                                   ),
//                                   letterSpacing: 0.0,
//                                   fontWeight: FlutterFlowTheme.of(context)
//                                       .labelMedium
//                                       .fontWeight,
//                                   fontStyle: FlutterFlowTheme.of(context)
//                                       .labelMedium
//                                       .fontStyle,
//                                 ),
//                                 searchTextStyle: FlutterFlowTheme.of(context)
//                                     .bodyMedium
//                                     .override(
//                                   font: GoogleFonts.roboto(
//                                     fontWeight: FlutterFlowTheme.of(context)
//                                         .bodyMedium
//                                         .fontWeight,
//                                     fontStyle: FlutterFlowTheme.of(context)
//                                         .bodyMedium
//                                         .fontStyle,
//                                   ),
//                                   letterSpacing: 0.0,
//                                   fontWeight: FlutterFlowTheme.of(context)
//                                       .bodyMedium
//                                       .fontWeight,
//                                   fontStyle: FlutterFlowTheme.of(context)
//                                       .bodyMedium
//                                       .fontStyle,
//                                 ),
//                                 textStyle: FlutterFlowTheme.of(context)
//                                     .bodyMedium
//                                     .override(
//                                   font: GoogleFonts.roboto(
//                                     fontWeight: FlutterFlowTheme.of(context)
//                                         .bodyMedium
//                                         .fontWeight,
//                                     fontStyle: FlutterFlowTheme.of(context)
//                                         .bodyMedium
//                                         .fontStyle,
//                                   ),
//                                   letterSpacing: 0.0,
//                                   fontWeight: FlutterFlowTheme.of(context)
//                                       .bodyMedium
//                                       .fontWeight,
//                                   fontStyle: FlutterFlowTheme.of(context)
//                                       .bodyMedium
//                                       .fontStyle,
//                                 ),
//                                 hintText: 'Type',
//                                 searchHintText: 'Search...',
//                                 icon: Icon(
//                                   Icons.keyboard_arrow_down_rounded,
//                                   color: FlutterFlowTheme.of(context)
//                                       .secondaryText,
//                                   size: 24,
//                                 ),
//                                 fillColor: FlutterFlowTheme.of(context)
//                                     .secondaryBackground,
//                                 elevation: 3,
//                                 borderColor:
//                                 FlutterFlowTheme.of(context).primaryText,
//                                 borderWidth: 1,
//                                 borderRadius: 8,
//                                 margin: const EdgeInsetsDirectional.fromSTEB(
//                                     12, 0, 12, 0),
//                                 hidesUnderline: true,
//                                 isOverButton: false,
//                                 isSearchable: true,
//                                 isMultiSelect: false,
//                               ),
//                             ].divide(const SizedBox(width: 32)),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
//                           child: Row(
//                             mainAxisSize: MainAxisSize.max,
//                             children: [
//                               Container(
//                                 width: 304,
//                                 child: TextFormField(
//                                   controller: _model.nameTextController2,
//                                   focusNode: _model.nameFocusNode2,
//                                   autofocus: false,
//                                   obscureText: false,
//                                   decoration: InputDecoration(
//                                     labelText: 'Working Hours (hh:mm - hh:mm)',
//                                     labelStyle: FlutterFlowTheme.of(context)
//                                         .labelMedium
//                                         .override(
//                                       font: GoogleFonts.roboto(
//                                         fontWeight:
//                                         FlutterFlowTheme.of(context)
//                                             .labelMedium
//                                             .fontWeight,
//                                         fontStyle:
//                                         FlutterFlowTheme.of(context)
//                                             .labelMedium
//                                             .fontStyle,
//                                       ),
//                                       letterSpacing: 0.0,
//                                       fontWeight:
//                                       FlutterFlowTheme.of(context)
//                                           .labelMedium
//                                           .fontWeight,
//                                       fontStyle:
//                                       FlutterFlowTheme.of(context)
//                                           .labelMedium
//                                           .fontStyle,
//                                     ),
//                                     alignLabelWithHint: false,
//                                     hintStyle: FlutterFlowTheme.of(context)
//                                         .labelMedium
//                                         .override(
//                                       font: GoogleFonts.roboto(
//                                         fontWeight:
//                                         FlutterFlowTheme.of(context)
//                                             .labelMedium
//                                             .fontWeight,
//                                         fontStyle:
//                                         FlutterFlowTheme.of(context)
//                                             .labelMedium
//                                             .fontStyle,
//                                       ),
//                                       letterSpacing: 0.0,
//                                       fontWeight:
//                                       FlutterFlowTheme.of(context)
//                                           .labelMedium
//                                           .fontWeight,
//                                       fontStyle:
//                                       FlutterFlowTheme.of(context)
//                                           .labelMedium
//                                           .fontStyle,
//                                     ),
//                                     enabledBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(
//                                         color: FlutterFlowTheme.of(context)
//                                             .primaryText,
//                                         width: 1,
//                                       ),
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                     focusedBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(
//                                         color: FlutterFlowTheme.of(context)
//                                             .primary,
//                                         width: 1,
//                                       ),
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                     errorBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(
//                                         color:
//                                         FlutterFlowTheme.of(context).error,
//                                         width: 1,
//                                       ),
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                     focusedErrorBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(
//                                         color:
//                                         FlutterFlowTheme.of(context).error,
//                                         width: 1,
//                                       ),
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                     filled: true,
//                                     fillColor: FlutterFlowTheme.of(context)
//                                         .secondaryBackground,
//                                     contentPadding:
//                                     const EdgeInsetsDirectional.fromSTEB(
//                                         20, 24, 20, 24),
//                                   ),
//                                   style: FlutterFlowTheme.of(context)
//                                       .bodyMedium
//                                       .override(
//                                     font: GoogleFonts.roboto(
//                                       fontWeight:
//                                       FlutterFlowTheme.of(context)
//                                           .bodyMedium
//                                           .fontWeight,
//                                       fontStyle:
//                                       FlutterFlowTheme.of(context)
//                                           .bodyMedium
//                                           .fontStyle,
//                                     ),
//                                     letterSpacing: 0.0,
//                                     fontWeight: FlutterFlowTheme.of(context)
//                                         .bodyMedium
//                                         .fontWeight,
//                                     fontStyle: FlutterFlowTheme.of(context)
//                                         .bodyMedium
//                                         .fontStyle,
//                                   ),
//                                   cursorColor:
//                                   FlutterFlowTheme.of(context).primary,
//                                   validator: _model.nameTextController2Validator
//                                       .asValidator(context),
//                                 ),
//                               ),
//                             ].divide(const SizedBox(width: 32)),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
//                           child: Row(
//                             mainAxisSize: MainAxisSize.max,
//                             children: [
//                               Expanded(
//                                 child: TextFormField(
//                                   controller: _model.nameTextController3,
//                                   focusNode: _model.nameFocusNode3,
//                                   autofocus: false,
//                                   obscureText: false,
//                                   decoration: InputDecoration(
//                                     labelText: 'Venue Description',
//                                     labelStyle: FlutterFlowTheme.of(context)
//                                         .labelMedium
//                                         .override(
//                                       font: GoogleFonts.roboto(
//                                         fontWeight:
//                                         FlutterFlowTheme.of(context)
//                                             .labelMedium
//                                             .fontWeight,
//                                         fontStyle:
//                                         FlutterFlowTheme.of(context)
//                                             .labelMedium
//                                             .fontStyle,
//                                       ),
//                                       letterSpacing: 0.0,
//                                       fontWeight:
//                                       FlutterFlowTheme.of(context)
//                                           .labelMedium
//                                           .fontWeight,
//                                       fontStyle:
//                                       FlutterFlowTheme.of(context)
//                                           .labelMedium
//                                           .fontStyle,
//                                     ),
//                                     alignLabelWithHint: false,
//                                     hintStyle: FlutterFlowTheme.of(context)
//                                         .labelMedium
//                                         .override(
//                                       font: GoogleFonts.roboto(
//                                         fontWeight:
//                                         FlutterFlowTheme.of(context)
//                                             .labelMedium
//                                             .fontWeight,
//                                         fontStyle:
//                                         FlutterFlowTheme.of(context)
//                                             .labelMedium
//                                             .fontStyle,
//                                       ),
//                                       letterSpacing: 0.0,
//                                       fontWeight:
//                                       FlutterFlowTheme.of(context)
//                                           .labelMedium
//                                           .fontWeight,
//                                       fontStyle:
//                                       FlutterFlowTheme.of(context)
//                                           .labelMedium
//                                           .fontStyle,
//                                     ),
//                                     enabledBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(
//                                         color: FlutterFlowTheme.of(context)
//                                             .primaryText,
//                                         width: 1,
//                                       ),
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                     focusedBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(
//                                         color: FlutterFlowTheme.of(context)
//                                             .primary,
//                                         width: 1,
//                                       ),
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                     errorBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(
//                                         color:
//                                         FlutterFlowTheme.of(context).error,
//                                         width: 1,
//                                       ),
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                     focusedErrorBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(
//                                         color:
//                                         FlutterFlowTheme.of(context).error,
//                                         width: 1,
//                                       ),
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                     filled: true,
//                                     fillColor: FlutterFlowTheme.of(context)
//                                         .secondaryBackground,
//                                     contentPadding:
//                                     const EdgeInsetsDirectional.fromSTEB(
//                                         20, 24, 20, 24),
//                                   ),
//                                   style: FlutterFlowTheme.of(context)
//                                       .bodyMedium
//                                       .override(
//                                     font: GoogleFonts.roboto(
//                                       fontWeight:
//                                       FlutterFlowTheme.of(context)
//                                           .bodyMedium
//                                           .fontWeight,
//                                       fontStyle:
//                                       FlutterFlowTheme.of(context)
//                                           .bodyMedium
//                                           .fontStyle,
//                                     ),
//                                     letterSpacing: 0.0,
//                                     fontWeight: FlutterFlowTheme.of(context)
//                                         .bodyMedium
//                                         .fontWeight,
//                                     fontStyle: FlutterFlowTheme.of(context)
//                                         .bodyMedium
//                                         .fontStyle,
//                                   ),
//                                   maxLines: null,
//                                   minLines: 1,
//                                   cursorColor:
//                                   FlutterFlowTheme.of(context).primary,
//                                   validator: _model.nameTextController3Validator
//                                       .asValidator(context),
//                                 ),
//                               ),
//                             ].divide(const SizedBox(width: 16)),
//                           ),
//                         ),
//                       ].divide(const SizedBox(height: 24)),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsetsDirectional.fromSTEB(24, 24, 24, 24),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.max,
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Align(
//                           alignment: const AlignmentDirectional(0, 0.05),
//                           child: FFButtonWidget(
//                             onPressed: () async {
//                               Navigator.pop(context);
//                             },
//                             text: 'Cancel',
//                             options: FFButtonOptions(
//                               height: 44,
//                               padding:
//                               const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
//                               iconPadding:
//                               const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
//                               color: FlutterFlowTheme.of(context).error,
//                               textStyle: FlutterFlowTheme.of(context)
//                                   .titleSmall
//                                   .override(
//                                 font: GoogleFonts.oswald(
//                                   fontWeight: FontWeight.normal,
//                                   fontStyle: FlutterFlowTheme.of(context)
//                                       .titleSmall
//                                       .fontStyle,
//                                 ),
//                                 color: FlutterFlowTheme.of(context)
//                                     .primaryBackground,
//                                 letterSpacing: 0.0,
//                                 fontWeight: FontWeight.normal,
//                                 fontStyle: FlutterFlowTheme.of(context)
//                                     .titleSmall
//                                     .fontStyle,
//                               ),
//                               elevation: 0,
//                               borderSide: BorderSide(
//                                 color: FlutterFlowTheme.of(context).alternate,
//                                 width: 2,
//                               ),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                         ),
//                         Align(
//                           alignment: const AlignmentDirectional(0, 0.05),
//                           child: FFButtonWidget(
//                             onPressed: () {
//                               print('Button pressed ...');
//                             },
//                             text: 'Save Changes',
//                             options: FFButtonOptions(
//                               height: 44,
//                               padding:
//                               const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
//                               iconPadding:
//                               const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
//                               color: FlutterFlowTheme.of(context).primary,
//                               textStyle: FlutterFlowTheme.of(context)
//                                   .titleSmall
//                                   .override(
//                                 font: GoogleFonts.oswald(
//                                   fontWeight: FontWeight.normal,
//                                   fontStyle: FlutterFlowTheme.of(context)
//                                       .titleSmall
//                                       .fontStyle,
//                                 ),
//                                 color: FlutterFlowTheme.of(context)
//                                     .primaryBackground,
//                                 letterSpacing: 0.0,
//                                 fontWeight: FontWeight.normal,
//                                 fontStyle: FlutterFlowTheme.of(context)
//                                     .titleSmall
//                                     .fontStyle,
//                               ),
//                               elevation: 3,
//                               borderSide: const BorderSide(
//                                 color: Colors.transparent,
//                                 width: 1,
//                               ),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ].divide(const SizedBox(height: 16)),
//               ),
//             ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation']!),
//           ),
//         ],
//       ),
//     );
//   }
// }
