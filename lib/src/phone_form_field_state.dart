part of 'phone_form_field.dart';

class PhoneFormFieldState extends FormFieldState<PhoneNumber> {
  late final PhoneController controller;
  late final FocusNode focusNode;

  @override
  PhoneFormField get widget => super.widget as PhoneFormField;

  @override
  void initState() {
    super.initState();

    controller = widget.controller ??
        PhoneController(
          initialValue: widget.initialValue ?? const PhoneNumber(isoCode: IsoCode.US, nsn: ''),
        );
    controller.addListener(_onControllerValueChanged);
    focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void dispose() {
    controller.removeListener(_onControllerValueChanged);
    super.dispose();
  }

  // overriding method from FormFieldState
  @override
  void didChange(PhoneNumber? value) {
    if (value == null) {
      return;
    }
    super.didChange(value);

    if (controller.value != value) {
      controller.value = value;
    }
  }

  void _onControllerValueChanged() {
    /// when the controller changes because the user called
    /// controller.value = x we need to change the value of the form field
    if (controller.value != value) {
      didChange(controller.value);
    }
  }

  void _onTextfieldChanged(String value) {
    controller.changeNationalNumber(value);
    didChange(controller.value);
    widget.onChanged?.call(controller.value);
  }

  // overriding method of form field, so when the user resets a form,
  // and subsequently every form field descendant, the controller is updated
  @override
  void reset() {
    controller.value = controller.initialValue;
    super.reset();
  }

  void _selectCountry(BuildContext context) async {
    if (!widget.isCountrySelectionEnabled) {
      return;
    }
    final selected = await widget.countrySelectorNavigator.show(context);
    if (selected != null) {
      controller.changeCountry(selected);
      didChange(controller.value);
      widget.onChanged?.call(controller.value);
    }
    focusNode.requestFocus();
  }

  Widget builder() {
    final bool isFocused = focusNode.hasFocus;
    final bool hasText = controller.value.nsn.isNotEmpty;
    final bool shouldFloat = isFocused || hasText;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => focusNode.requestFocus(),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Row(
            children: [
              Container(
                decoration: widget.inputDecoration,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                height: 48,
                child: AnimatedBuilder(
                  animation: controller,
                  builder: (context, _) => CountryButton(
                      key: const ValueKey('country-code-chip'),
                      isoCode: controller.value.isoCode,
                      onTap: widget.enabled ? () => _selectCountry(context) : null,
                      showFlag: widget.countryButtonStyle.showFlag,
                      showDialCode: widget.countryButtonStyle.showDialCode,
                      showDropdownIcon: widget.countryButtonStyle.showDropdownIcon,
                      textStyle: TextStyle(color: widget.inputTextColor, fontSize: 14),
                      iconColor: widget.inputTextColor,
                      flagSize: widget.countryButtonStyle.flagSize),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Container(
                  decoration: widget.inputDecoration,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextField(
                    cursorHeight: 16,
                    controller: controller._formattedNationalNumberController,
                    focusNode: focusNode,
                    enabled: widget.enabled,
                    onChanged: _onTextfieldChanged,
                    style: TextStyle(
                      color: widget.inputTextColor ?? Colors.black87,
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      prefixIconConstraints: const BoxConstraints(
                        minWidth: 25,
                      ),
                      prefixIcon: widget.prefix != null
                          ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [widget.prefix!],
                      )
                          : null,
                      contentPadding: const EdgeInsets.only(top: 10.0, bottom: 0.0),
                      border: InputBorder.none,
                      hintText: '',
                    ),
                    keyboardType: widget.keyboardType,
                    inputFormatters: widget.inputFormatters ??
                        [
                          FilteringTextInputFormatter.allow(
                            RegExp(
                              '[${AllowedCharacters.plus}${AllowedCharacters.digits}${AllowedCharacters.punctuation}]',
                            ),
                          ),
                        ],
                  ),
                ),
              ),
            ],
          ),

          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            left: 158,
            top: shouldFloat ? 6.0 : 12.0,
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: widget.labelStyle.copyWith(
                fontSize: shouldFloat ? 12.0 : 16.0,
              ),
              child: Text(widget.decoration.labelText ?? ''),
            ),
          ),


          if (errorText != null)
            Positioned(
              bottom: -25,
              left: 130,
              child: Text(
                widget.errorTextLocalizedMessage??errorText!,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
