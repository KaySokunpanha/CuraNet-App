import os

files = [
    r"g:\Project\curanet\lib\widgets\custom_elevated_button.dart",
    r"g:\Project\curanet\lib\widgets\custom_text_form_field.dart"
]

for path in files:
    with open(path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    if "custom_elevated_button.dart" in path:
        content = content.replace("_buildElevatedButtonWidget()", "_buildElevatedButtonWidget(context)")
        content = content.replace("_buildElevatedButtonWidget {", "_buildElevatedButtonWidget(BuildContext context) {")
        # Also handle the case where it's defined as _buildElevatedButtonWidget() {
        content = content.replace("_buildElevatedButtonWidget() {", "_buildElevatedButtonWidget(BuildContext context) {")
        
        # Insert theme definition
        if "final theme = Theme.of(context);" not in content.split("_buildElevatedButtonWidget(BuildContext context) {")[1]:
             content = content.replace(
                "_buildElevatedButtonWidget(BuildContext context) {",
                "_buildElevatedButtonWidget(BuildContext context) {\n    final theme = Theme.of(context);"
            )

    elif "custom_text_form_field.dart" in path:
        content = content.replace("_buildTextFormFieldWidget()", "_buildTextFormFieldWidget(context)")
        content = content.replace("_buildTextFormFieldWidget {", "_buildTextFormFieldWidget(BuildContext context) {")
        content = content.replace("_buildTextFormFieldWidget() {", "_buildTextFormFieldWidget(BuildContext context) {")
        
        # Insert theme definition
        if "final theme = Theme.of(context);" not in content.split("_buildTextFormFieldWidget(BuildContext context) {")[1]:
             content = content.replace(
                "_buildTextFormFieldWidget(BuildContext context) {",
                "_buildTextFormFieldWidget(BuildContext context) {\n    final theme = Theme.of(context);"
            )

    with open(path, 'w', encoding='utf-8') as f:
        f.write(content)
    print(f"Fixed {path}")
