import 'package:flutter/material.dart';
import '../models/disease_model.dart';
import '../models/scan_model.dart';
import '../models/user_model.dart';

class MockData {
  MockData._();

  static const UserModel currentUser = UserModel(
    // TODO: replace with the logged-in user's real name once auth/backend is connected.
    fullName: 'Farmer',
    email: 'Farmer@gmail.com',
    farmName: 'Farm Name',
    totalScans: 347,
    diseasesFound: 28,
    farmBlocks: 6,
  );

  static const DiseaseModel bayoud = DiseaseModel(
    id: 'bayoud',
    name: 'Bayoud Disease',
    scientificName: 'Fusarium oxysporum f. sp. albedinis',
    severity: 'Critical',
    recordedCases: 142,
    description:
    'Soil-borne fungal pathogen causing wilting of lower fronds and '
        'vascular discoloration. Spreads via contaminated soil and water.',
    icon: Icons.eco,
    swatch: Color(0xFF7C9473),
    recommendedActions: [
      'Collect soil sample for lab confirmation',
      'Isolate affected palms immediately',
      'Apply systemic fungicide to root zone',
    ],
    differentialAnalysis: [
      DifferentialResult(name: 'Bayoud (Fusarium Wilt)', confidence: 94),
      DifferentialResult(name: 'Black Scorch', confidence: 12),
      DifferentialResult(name: 'Khamedj Rot', confidence: 8),
    ],
  );

  static const DiseaseModel blackScorch = DiseaseModel(
    id: 'black_scorch',
    name: 'Black Scorch',
    scientificName: 'Thielaviopsis paradoxa',
    severity: 'High',
    recordedCases: 87,
    description:
    'Fungal infection causing black, scorched lesions on fronds and '
        'trunk tissue, often entering through pruning wounds.',
    icon: Icons.grass,
    swatch: Color(0xFF5C7A5C),
    recommendedActions: [
      'Remove and destroy infected fronds',
      'Disinfect pruning tools between palms',
      'Apply protective wound sealant after trimming',
    ],
    differentialAnalysis: [
      DifferentialResult(name: 'Black Scorch', confidence: 91),
      DifferentialResult(name: 'Bayoud Disease', confidence: 14),
      DifferentialResult(name: 'Graphiola Leaf Spot', confidence: 6),
    ],
  );

  static const DiseaseModel khamedj = DiseaseModel(
    id: 'khamedj',
    name: 'Khamedj (Inflorescence Rot)',
    scientificName: 'Mauginiella scaettae',
    severity: 'Medium',
    recordedCases: 54,
    description:
    'Attacks the inflorescence during humid conditions, causing rot '
        'and blackening of the flower strands before fruit set.',
    icon: Icons.local_florist,
    swatch: Color(0xFFC97B4A),
    recommendedActions: [
      'Remove and destroy affected inflorescences',
      'Improve pollination-area ventilation',
      'Apply preventive fungicide before flowering',
    ],
    differentialAnalysis: [
      DifferentialResult(name: 'Khamedj Rot', confidence: 94),
      DifferentialResult(name: 'Bayoud Disease', confidence: 9),
      DifferentialResult(name: 'Black Scorch', confidence: 4),
    ],
  );

  static const DiseaseModel graphiola = DiseaseModel(
    id: 'graphiola',
    name: 'Graphiola Leaf Spot',
    scientificName: 'Graphiola phoenicis',
    severity: 'Low',
    recordedCases: 31,
    description:
    'Also known as "false smut". Produces small raised black pustules '
        'on fronds; largely cosmetic but signals humid, dense canopies.',
    icon: Icons.spa,
    swatch: Color(0xFF8B6F4E),
    recommendedActions: [
      'Thin canopy to improve airflow',
      'Remove heavily spotted fronds',
      'Monitor — treatment rarely required',
    ],
    differentialAnalysis: [
      DifferentialResult(name: 'Graphiola Leaf Spot', confidence: 87),
      DifferentialResult(name: 'Black Scorch', confidence: 10),
      DifferentialResult(name: 'Khamedj Rot', confidence: 3),
    ],
  );

  static List<DiseaseModel> get diseaseLibrary => [bayoud, blackScorch, khamedj, graphiola];

  static List<AlertModel> get activeAlerts => const [];

  static List<ScanModel> get recentScans => const [];

  static List<ScanModel> get scanHistory => const [];


  static ScanModel simulateDetection() {
    return const ScanModel(
      id: 'scan_new',
      disease: bayoud,
      blockLabel: 'Block C-4 · Palm #12',
      dateLabel: '07 Aug 2026',
      timeAgo: 'just now',
      confidence: 94,
    );
  }
}
