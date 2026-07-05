import 'dart:io';

void main() async {
  final dir = Directory('lib');
  final files = dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));

  for (final file in files) {
    String content = file.readAsStringSync();
    bool changed = false;

    // Pattern to match import, export, or part directives
    final RegExp directiveRegex = RegExp(r"(import|export|part)\s+['""](.*?)['""];");

    final newContent = content.replaceAllMapped(directiveRegex, (match) {
      final directive = match.group(1);
      final importPath = match.group(2)!;
      
      // If it's a package or dart import, skip it
      if (importPath.startsWith('package:') || importPath.startsWith('dart:')) {
        return match.group(0)!;
      }

      // Check if current relative path exists
      final uri = Uri.file(file.path.replaceAll('\\', '/'));
      final targetUri = uri.resolve(importPath);
      final targetFile = File(targetUri.toFilePath());
      
      if (targetFile.existsSync()) {
        return match.group(0)!; // No change needed
      }
      
      // If it doesn't exist, let's try to fix it.
      // 1. Maybe it just needs an extra '../' (because the file moved one level down)
      final try1 = uri.resolve('../$importPath');
      if (File(try1.toFilePath()).existsSync()) {
        changed = true;
        return "$directive '../$importPath';";
      }
      
      // 2. Maybe it contains old paths like 'features/dashboard' and needs to point to 'features/user/dashboard'
      String adjustedImport = importPath;
      
      // Replace feature paths (must do delegate specific ones first)
      adjustedImport = adjustedImport.replaceAll('features/profile/presentation/screens/delegate_', 'features/delegates/profile/presentation/screens/delegate_');
      adjustedImport = adjustedImport.replaceAll('features/delegation/presentation/screens/delegate_', 'features/delegates/delegation/presentation/screens/delegate_');
      
      // Then the generic ones
      adjustedImport = adjustedImport.replaceAll('features/dashboard/', 'features/user/dashboard/');
      adjustedImport = adjustedImport.replaceAll('features/election/', 'features/user/election/');
      adjustedImport = adjustedImport.replaceAll('features/election_proposal/', 'features/user/election_proposal/');
      adjustedImport = adjustedImport.replaceAll('features/kyc/', 'features/user/kyc/');
      adjustedImport = adjustedImport.replaceAll('features/vote_execution/', 'features/user/vote_execution/');
      adjustedImport = adjustedImport.replaceAll('features/delegation/', 'features/user/delegation/');
      adjustedImport = adjustedImport.replaceAll('features/profile/', 'features/user/profile/');

      // Now check if adjustedImport works directly (maybe from core/router)
      final try2 = uri.resolve(adjustedImport);
      if (File(try2.toFilePath()).existsSync()) {
        changed = true;
        return "$directive '$adjustedImport';";
      }

      // 3. Or maybe it needs BOTH an extra '../' AND the path adjustment
      final try3 = uri.resolve('../$adjustedImport');
      if (File(try3.toFilePath()).existsSync()) {
        changed = true;
        return "$directive '../$adjustedImport';";
      }

      // If nothing works, just return the original (flutter analyze will catch it)
      return match.group(0)!;
    });

    if (changed) {
      file.writeAsStringSync(newContent);
      print('Fixed imports in: ${file.path}');
    }
  }
}
