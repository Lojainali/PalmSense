import 'package:flutter/material.dart';
import '../models/disease_model.dart';
import '../models/scan_model.dart';
import '../models/user_model.dart';

/// Central place holding placeholder data so every screen has something
/// realistic to render. Swap this out for real API/repository calls once
/// the backend is ready — screens only depend on these model shapes.
class MockData {
  MockData._();

  static const UserModel currentUser = UserModel(
    fullName: 'Sara Al-Ahmed',
    email: 'sara.ahmed@palmfarm.ae',
    farmName: 'Al-Ahmed Date Farm',
    totalScans: 347,
    diseasesFound: 28,
    farmBlocks: 6,
  );

  static final DiseaseModel bayoud = DiseaseModel(
    id: 'bayoud',
    name: 'Bayoud Disease',
    scientificName: 'Fusarium oxysporum f. sp. albedinis',
    severity: 'Critical',
    recordedCases: 142,
    description:
    'Soil-borne fungal pathogen causing wilting of lower fronds and '
        'vascular discoloration. Spreads via contaminated soil and water.',
    icon: Icons.eco,
    swatch: const Color(0xFF7C9473),
    recommendedActions: const [
      'Collect soil sample for lab confirmation',
      'Isolate affected palms immediately',
      'Apply systemic fungicide to root zone',
    ],
    differentialAnalysis: const [
      DifferentialResult(name: 'Bayoud (Fusarium Wilt)', confidence: 94),
      DifferentialResult(name: 'Black Scorch', confidence: 12),
      DifferentialResult(name: 'Khamedj Rot', confidence: 8),
    ],
  );

  static final DiseaseModel blackScorch = DiseaseModel(
    id: 'black_scorch',
    name: 'Black Scorch',
    scientificName: 'Thielaviopsis paradoxa',
    severity: 'High',
    recordedCases: 87,
    description:
    'Fungal infection causing black, scorched lesions on fronds and '
        'trunk tissue, often entering through pruning wounds.',
    icon: Icons.grass,
    swatch: const Color(0xFF5C7A5C),
    recommendedActions: const [
      'Remove and destroy infected fronds',
      'Disinfect pruning tools between palms',
      'Apply protective wound sealant after trimming',
    ],
    differentialAnalysis: const [
      DifferentialResult(name: 'Black Scorch', confidence: 91),
      DifferentialResult(name: 'Bayoud Disease', confidence: 14),
      DifferentialResult(name: 'Graphiola Leaf Spot', confidence: 6),
    ],
  );

  static final DiseaseModel khamedj = DiseaseModel(
    id: 'khamedj',
    name: 'Khamedj (Inflorescence Rot)',
    scientificName: 'Mauginiella scaettae',
    severity: 'Medium',
    recordedCases: 54,
    description:
    'Attacks the inflorescence during humid conditions, causing rot '
        'and blackening of the flower strands before fruit set.',
    icon: Icons.local_florist,
    swatch: const Color(0xFFC97B4A),
    recommendedActions: const [
      'Remove and destroy affected inflorescences',
      'Improve pollination-area ventilation',
      'Apply preventive fungicide before flowering',
    ],
    differentialAnalysis: const [
      DifferentialResult(name: 'Khamedj Rot', confidence: 94),
      DifferentialResult(name: 'Bayoud Disease', confidence: 9),
      DifferentialResult(name: 'Black Scorch', confidence: 4),
    ],
  );

  static final DiseaseModel graphiola = DiseaseModel(
    id: 'graphiola',
    name: 'Graphiola Leaf Spot',
    scientificName: 'Graphiola phoenicis',
    severity: 'Low',
    recordedCases: 31,
    description:
    'Also known as "false smut". Produces small raised black pustules '
        'on fronds; largely cosmetic but signals humid, dense canopies.',
    icon: Icons.spa,
    swatch: const Color(0xFF8B6F4E),
    recommendedActions: const [
      'Thin canopy to improve airflow',
      'Remove heavily spotted fronds',
      'Monitor — treatment rarely required',
    ],
    differentialAnalysis: const [
      DifferentialResult(name: 'Graphiola Leaf Spot', confidence: 87),
      DifferentialResult(name: 'Black Scorch', confidence: 10),
      DifferentialResult(name: 'Khamedj Rot', confidence: 3),
    ],
  );

  static List<DiseaseModel> get diseaseLibrary => [bayoud, blackScorch, khamedj, graphiola];

  static List<AlertModel> get activeAlerts => const [
    AlertModel(diseaseName: 'Bayoud Disease', blockLabel: 'Block C-4', severity: 'High'),
    AlertModel(diseaseName: 'Black Scorch', blockLabel: 'Block A-7', severity: 'Medium'),
  ];

  static List<ScanModel> get recentScans => [
    ScanModel(
      id: 'scan_1',
      disease: khamedj,
      blockLabel: 'Block C-4 · Palm #12',
      dateLabel: '07 Aug 2026',
      timeAgo: '2h ago',
      confidence: 94,
    ),
    ScanModel(
      id: 'scan_2',
      disease: graphiola,
      blockLabel: 'Block A-2 · Palm #05',
      dateLabel: '07 Aug 2026',
      timeAgo: '5h ago',
      confidence: 87,
    ),
  ];

  static List<ScanModel> get scanHistory => [
    ...recentScans,
    ScanModel(
      id: 'scan_3',
      disease: bayoud,
      blockLabel: 'Block C-4 · Palm #09',
      dateLabel: '05 Aug 2026',
      timeAgo: '2d ago',
      confidence: 91,
    ),
    ScanModel(
      id: 'scan_4',
      disease: blackScorch,
      blockLabel: 'Block A-7 · Palm #21',
      dateLabel: '03 Aug 2026',
      timeAgo: '4d ago',
      confidence: 88,
    ),
  ];

  /// Result produced when the camera "captures" a leaf — used by ScanCubit
  /// to simulate an AI analysis without a real backend.
  static ScanModel simulateDetection() {
    return ScanModel(
      id: 'scan_new',
      disease: bayoud,
      blockLabel: 'Block C-4 · Palm #12',
      dateLabel: '07 Aug 2026',
      timeAgo: 'just now',
      confidence: 94,
    );
  }
}
