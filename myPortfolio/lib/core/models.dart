class WorkItem {
  final String title;
  final String subtitle;
  final List<String> tags;
  final String imageUrl;
  final String? projectUrl;

  const WorkItem({
    required this.title,
    required this.subtitle,
    required this.tags,
    required this.imageUrl,
    this.projectUrl,
  });
}

class Stage {
  final String number;
  final String title;
  final String detail;
  bool isOpen;

  Stage({
    required this.number,
    required this.title,
    required this.detail,
    this.isOpen = false,
  });
}

final List<WorkItem> portfolioWorks = [
  WorkItem(
    title: 'E-COMMERCE APP',
    subtitle: 'A full featured shopping app with cart, payments and order tracking',
    tags: ['Flutter', 'Mobile App'],
    imageUrl: 'https://images.unsplash.com/photo-1563013544-824ae1b704d3?w=600&q=80',
    projectUrl: 'https://github.com/Thelma-I',
  ),
  WorkItem(
    title: 'UI/UX DESIGN',
    subtitle: 'Clean modern interface designs for web and mobile platforms',
    tags: ['UI/UX', 'Web Design'],
    imageUrl: 'https://images.unsplash.com/photo-1561070791-2526d30994b5?w=600&q=80',
    projectUrl: 'https://github.com/Thelma-I',
  ),
  WorkItem(
    title: 'MOBILE APP',
    subtitle: 'Cross platform mobile application built with Flutter and Python backend',
    tags: ['Flutter', 'Python'],
    imageUrl: 'https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c?w=600&q=80',
    projectUrl: 'https://github.com/Thelma-I',
  ),
  WorkItem(
    title: 'WEB PLATFORM',
    subtitle: 'Responsive web platform with modern design and smooth animations',
    tags: ['Web Design', 'UI/UX'],
    imageUrl: 'https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=600&q=80',
    projectUrl: 'https://github.com/Thelma-I',
  ),
];
List<Stage> buildStages() => [
  Stage(
    number: 'STAGE 1',
    title: 'DISCOVERY',
    detail:
        'We start with a detailed conversation about your goals, target audience '
        'and project requirements. I ask the right questions to fully understand '
        'what you need before writing a single line of code.',
    isOpen: true,
  ),
  Stage(
    number: 'STAGE 2',
    title: 'PLANNING',
    detail:
        'I map out the full project structure — screens, features, data flow '
        'and tech stack. You get a clear timeline and milestone breakdown before we begin.',
  ),
  Stage(
    number: 'STAGE 3',
    title: 'DESIGN',
    detail:
        'Wireframes and high fidelity UI designs are created first so you can '
        'see exactly how your product will look and feel before development starts.',
  ),
  Stage(
    number: 'STAGE 4',
    title: 'DEVELOPMENT',
    detail:
        'Clean, well structured code using Flutter, Python or whatever fits '
        'your project best. I keep you updated throughout with regular progress demos.',
  ),
  Stage(
    number: 'STAGE 5',
    title: 'TESTING',
    detail:
        'Thorough testing across devices and screen sizes. Every feature is '
        'checked, bugs are fixed and performance is optimised before delivery.',
  ),
  Stage(
    number: 'STAGE 6',
    title: 'DELIVERY',
    detail:
        'Final handoff with full documentation, deployment support and a '
        'post launch check in to make sure everything runs perfectly.',
  ),
];

// ── SKILLS ──────────────────────────────────────────
const List<String> skills = [
  'Flutter',
  'Python',
  'Web Design',
  'Mobile App Design',
  'UI / UX',
  'REST APIs',
  'Firebase',
];

// ── PASSIONS ────────────────────────────────────────
const List<String> passions = [
  'Mobile Applications',
  'Clean UI Design',
  'E-commerce Platforms',
  'Cross Platform Apps',
  'User Experience',
  'Problem Solving',
  'Continuous Learning',
];