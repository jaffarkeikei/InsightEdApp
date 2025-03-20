class SubjectUtils {
  // Get abbreviated form of subject name
  static String getAbbreviation(String subjectName) {
    // Dictionary of common subject abbreviations
    final Map<String, String> abbreviations = {
      'Mathematics': 'MAT',
      'English': 'ENG',
      'Kiswahili': 'KIS',
      'Science': 'SCI',
      'Science and Technology': 'S&T',
      'Social Studies': 'SST',
      'Religious Education': 'RE',
      'Christian Religious Education': 'CRE',
      'Islamic Religious Education': 'IRE',
      'Creative Arts': 'CA',
      'Physical Education': 'PE',
      'Physical and Health Education': 'PHE',
      'Agriculture': 'AGR',
      'Home Science': 'HS',
      'Business Studies': 'BS',
      'Life Skills': 'LS',
      'Integrated Science': 'IS',
      'Health Education': 'HE',
      'Pre-Technical Education': 'PTE',
      'History': 'HIS',
      'Geography': 'GEO',
      'Chemistry': 'CHE',
      'Physics': 'PHY',
      'Biology': 'BIO',
    };

    // Return the abbreviation if it exists, otherwise create one from first 3 letters
    if (abbreviations.containsKey(subjectName)) {
      return abbreviations[subjectName]!;
    } else {
      // If the subject has multiple words, use first letters of each word
      final words = subjectName.split(' ');
      if (words.length > 1) {
        String abbr = '';
        for (var word in words) {
          if (word.isNotEmpty) {
            abbr += word[0];
          }
        }
        return abbr.length > 1
            ? abbr.toUpperCase()
            : subjectName
                .substring(0, min(3, subjectName.length))
                .toUpperCase();
      }

      // Otherwise use first 3 letters
      return subjectName.substring(0, min(3, subjectName.length)).toUpperCase();
    }
  }

  // Helper function to find minimum of two numbers
  static int min(int a, int b) => a < b ? a : b;
}
