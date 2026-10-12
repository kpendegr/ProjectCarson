import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RoutineStorage.load();
  runApp(const MainApp());
}

bool bounceEnabled = true;

/// ---------------- STORAGE ----------------

class RoutineStorage {
  static const String routineKey = "routines_data";
  static const String bounceKey = "bounce_setting";

  static Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    final data = routines.map((r) => r.toJson()).toList();
    await prefs.setString(routineKey, jsonEncode(data));
    await prefs.setBool(bounceKey, bounceEnabled);
  }

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    bounceEnabled = prefs.getBool(bounceKey) ?? true;

    final raw = prefs.getString(routineKey);
    if (raw == null) {
      routines = defaultRoutines();
      return;
    }

    final decoded = jsonDecode(raw) as List;
    routines = decoded.map((e) => Routine.fromJson(e)).toList();
  }
}

/// ---------------- APP ----------------

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark, primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}

/// ---------------- DATA ----------------

class StepData {
  String title;
  int duration;
  String instructionImage; 
  String ballImage;

  StepData({
    required this.title,
    required this.duration,
    required this.instructionImage,
    required this.ballImage,
  });

  Map<String, dynamic> toJson() => {
        "title": title,
        "duration": duration,
        "instructionImage": instructionImage,
        "ballImage": ballImage,
      };

  static StepData fromJson(Map<String, dynamic> json) {
    return StepData(
      title: json["title"],
      duration: json["duration"],
      instructionImage: json["instructionImage"] ?? "",
      ballImage: json["ballImage"] ?? "",
    );
  }
}

class Routine {
  String name;
  Color color;
  List<StepData> steps;

  Routine({
    required this.name,
    required this.steps,
    required this.color,
  });

  Map<String, dynamic> toJson() => {
        "name": name,
        "color": color.value,
        "steps": steps.map((s) => s.toJson()).toList(),
      };

  static Routine fromJson(Map<String, dynamic> json) {
    return Routine(
      name: json["name"],
      color: Color(json["color"]),
      steps: (json["steps"] as List).map((s) => StepData.fromJson(s)).toList(),
    );
  }
}

/// ---------------- DEFAULT DATA ----------------

List<Routine> routines = [];

List<Routine> defaultRoutines() {
  return [
    Routine(name: "Morning Routine", color: Colors.blue, steps: [
       StepData(title: "Brush Teeth", duration: 30, instructionImage: "", ballImage: ""),
    ]),
  ];
}

/// ---------------- EDITING SCREENS ----------------

class RoutineEditor extends StatefulWidget {
  final Routine routine;
  const RoutineEditor({super.key, required this.routine});

  @override
  State<RoutineEditor> createState() => _RoutineEditorState();
}

class _RoutineEditorState extends State<RoutineEditor> {
  late TextEditingController nameController;

  // =========================================================
  // MANUAL ASSET LISTS
  // =========================================================
  final List<String> staticImages = [
    "assets/images/toothbrush.png",
    "assets/images/pills.png",
    "assets/images/drugs.png",
    "assets/images/medicine.png",
    "assets/images/stop.png",
    "assets/images/wateron.png",
    "assets/images/wateroffblack.png",
    "assets/images/privatewash.png",
    "assets/images/hand-soap.png",
    "assets/images/footwash.png",
    "assets/images/scrubbody.png",
    "assets/images/hair-washing.png",
    "assets/images/washing.png",
    "assets/images/rinse.png",
    "assets/images/underarm.png",
    "assets/images/scrubbbb.png",
    "assets/images/shower.png",
    "assets/images/mouthwashteen.png",
    "assets/images/mouthwashboy.png",
    "assets/images/mouthwash.png",
    "assets/images/spit.png",
    "assets/images/gargle.png",
    "assets/images/rinsemouth.png",
    "assets/images/cologne.png",
    "assets/images/perfume.png",
    "assets/images/sport-shoe.png",
    "assets/images/deodorant.png",
    "assets/images/put-on-deodorant.png",
    "assets/images/boxers.png",
    "assets/images/bra.png",
    "assets/images/underwear.png",
    "assets/images/socks.png",
    "assets/images/trousers.png",
    "assets/images/tshirt.png",
    "assets/images/putShirtOn.png",
    "assets/images/girlbrushhair.png",
    "assets/images/boybrushhair.png",
    "assets/images/hairbrush.png",
    "assets/images/toothpaste.png",
    "assets/images/brushtongue.png",
    "assets/images/tooth-cleaningbw.png",
    "assets/images/toothbrushaway.png",
    "assets/images/tooth-cleaning.png",
    "assets/images/toothpaste.jpg"
  ];

  final List<String> gifImages = [
    "assets/gifs/medstime.gif",
    "assets/gifs/brushhairrrrgif.gif",
    "assets/gifs/putonsock.gif",
    "assets/gifs/socksputon.webp",
    "assets/gifs/putonpants.gif",
    "assets/gifs/dressing-up-daniel-spencer.gif",
    "assets/gifs/snoopy-changeshirt.gif",
    "assets/gifs/donald-duck-donaldgargle.gif",
    "assets/gifs/spitintosink.gif",
    "assets/gifs/rinsebooty.gif",
    "assets/gifs/rinseoffsoapppp.gif",
    "assets/gifs/dryoff.gif",
    "assets/gifs/rinseoffsoap.gif",
    "assets/gifs/scrubbodybootie.gif",
    "assets/gifs/hairwash.gif",
    "assets/gifs/showertimehammerlol.gif",
    "assets/gifs/showerturnon.gif",
    "assets/gifs/give-your-hair-a-scrub-kutu.gif",
    "assets/gifs/tongue-scraping.gif",
    "assets/gifs/girlbrushteeth.gif",
    "assets/gifs/barbie-brushes-her-teeth.gif"
  ];

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.routine.name);
  }

  void save() {
    RoutineStorage.save();
    setState(() {});
  }

  void _showImagePicker(bool showGifs, Function(String) onSelected) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return CustomScrollView(
              controller: scrollController,
              slivers: [
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: Text("Select Graphic", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                  ),
                ),
                SliverToBoxAdapter(
                  child: ListTile(
                    leading: const Icon(Icons.block, color: Colors.red),
                    title: const Text("None (Text Only)"),
                    onTap: () { onSelected(""); Navigator.pop(context); },
                  ),
                ),
                const SliverToBoxAdapter(child: Padding(padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: Text("IMAGES", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)))),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10),
                    delegate: SliverChildBuilderDelegate((context, i) => _buildGridItem(staticImages[i], onSelected), childCount: staticImages.length),
                  ),
                ),
                if (showGifs) ...[
                  const SliverToBoxAdapter(child: Padding(padding: EdgeInsets.fromLTRB(16, 24, 16, 8), child: Text("GIFS", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)))),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10),
                      delegate: SliverChildBuilderDelegate((context, i) => _buildGridItem(gifImages[i], onSelected), childCount: gifImages.length),
                    ),
                  ),
                ],
                const SliverToBoxAdapter(child: SizedBox(height: 40)),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildGridItem(String path, Function(String) onSelected) {
    return GestureDetector(
      onTap: () { onSelected(path); Navigator.pop(context); },
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.blueAccent, width: 2)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(path, fit: BoxFit.contain, errorBuilder: (c, e, s) => const Icon(Icons.broken_image, color: Colors.black26)),
        ),
      ),
    );
  }

  Widget _buildImageSelector(String label, String currentPath, bool allowGifs, Function(String) onUpdate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _showImagePicker(allowGifs, onUpdate),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white24)),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 60, height: 60, color: Colors.white,
                    child: currentPath.isEmpty ? const Icon(Icons.block, color: Colors.grey) : Image.asset(currentPath, fit: BoxFit.contain),
                  ),
                ),
                const SizedBox(width: 16),
                Text(currentPath.isEmpty ? "Select Asset" : "Change Asset", style: const TextStyle(color: Colors.blueAccent)),
                const Spacer(),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  void editStep(StepData step) {
    TextEditingController titleCtrl = TextEditingController(text: step.title);
    TextEditingController durCtrl = TextEditingController(text: step.duration.toString());
    String selInstr = step.instructionImage;
    String selBall = step.ballImage;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text("Edit Step"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: "Step Name")),
                TextField(controller: durCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Duration (sec)")),
                const SizedBox(height: 25),
                _buildImageSelector("Instruction Graphic (Gifs)", selInstr, true, (path) => setDialogState(() => selInstr = path)),
                _buildImageSelector("Ball Image (Static Only)", selBall, false, (path) => setDialogState(() => selBall = path)),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
            TextButton(onPressed: () { setState(() { step.title = titleCtrl.text; step.duration = int.tryParse(durCtrl.text) ?? 5; step.instructionImage = selInstr; step.ballImage = selBall; }); save(); Navigator.pop(context); }, child: const Text("Save")),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: TextField(controller: nameController, style: const TextStyle(color: Colors.white), onSubmitted: (v) { widget.routine.name = v; save(); })),
      body: Column(
        children: [
          Expanded(
            child: ReorderableListView(
              onReorder: (oldIdx, newIdx) { setState(() { if (newIdx > oldIdx) newIdx -= 1; final item = widget.routine.steps.removeAt(oldIdx); widget.routine.steps.insert(newIdx, item); save(); }); },
              children: [
                for (final s in widget.routine.steps)
                  ListTile(key: ValueKey(s), leading: const Icon(Icons.drag_handle), title: Text(s.title), subtitle: Text("${s.duration}s"), trailing: Row(mainAxisSize: MainAxisSize.min, children: [IconButton(icon: const Icon(Icons.edit), onPressed: () => editStep(s)), IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () { setState(() => widget.routine.steps.remove(s)); save(); })])),
              ],
            ),
          ),
          Padding(padding: const EdgeInsets.all(16), child: ElevatedButton(style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)), child: const Text("Add Step"), onPressed: () { setState(() => widget.routine.steps.add(StepData(title: "New Step", duration: 10, instructionImage: "", ballImage: ""))); save(); })),
        ],
      ),
    );
  }
}

/// ---------------- SETTINGS & HOME ----------------

class SettingsScreen extends StatefulWidget { const SettingsScreen({super.key}); @override State<SettingsScreen> createState() => _SettingsScreenState(); }
class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        children: [
          SwitchListTile(title: const Text("Enable Bouncing"), value: bounceEnabled, onChanged: (v) { setState(() => bounceEnabled = v); RoutineStorage.save(); }),
          const Divider(),
          for (final r in routines) ListTile(leading: CircleAvatar(backgroundColor: r.color), title: Text(r.name), trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () { setState(() => routines.remove(r)); RoutineStorage.save(); }), onTap: () async { await Navigator.push(context, MaterialPageRoute(builder: (_) => RoutineEditor(routine: r))); setState(() {}); }),
          ListTile(leading: const Icon(Icons.add), title: const Text("Add New Routine"), onTap: () { setState(() => routines.add(Routine(name: "New Routine", color: Colors.purple, steps: []))); RoutineStorage.save(); }),
        ],
      ),
    );
  }
}

class HomeScreen extends StatefulWidget { const HomeScreen({super.key}); @override State<HomeScreen> createState() => _HomeScreenState(); }
class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text("Daily Support"), actions: [IconButton(icon: const Icon(Icons.settings), onPressed: () async { await Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())); setState(() {}); })]),
      body: ListView.builder(padding: const EdgeInsets.all(12), itemCount: routines.length, itemBuilder: (context, i) { final r = routines[i]; return Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: SizedBox(height: 100, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: r.color), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ModeScreen(routine: r))), child: Text(r.name, style: const TextStyle(fontSize: 24, color: Colors.white))))); }),
    );
  }
}

class CompletionScreen extends StatelessWidget { const CompletionScreen({super.key}); @override Widget build(BuildContext context) { return Scaffold(backgroundColor: Colors.black, body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.thumb_up, color: Colors.green, size: 150), const SizedBox(height: 30), const Text("GOOD JOB!", style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white)), const SizedBox(height: 50), ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20)), onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst), child: const Text("EXIT ROUTINE", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)))]))); } }

/// ---------------- MODE SCREEN ----------------

class ModeScreen extends StatefulWidget { final Routine routine; const ModeScreen({super.key, required this.routine}); @override State<ModeScreen> createState() => _ModeScreenState(); }
class _ModeScreenState extends State<ModeScreen> with SingleTickerProviderStateMixin {
  int stepIndex = 0; int timeLeft = 0; bool showInstruction = true; Timer? _timer; late AnimationController controller;
  double x = 0; double y = 0; double dx = 1.5; double dy = 1.5; bool initialized = false;
  final double ballRadius = 140; // Even bigger ball

  @override
  void initState() { super.initState(); controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 16))..addListener(moveBall); controller.repeat(); startStep(); }
  @override
  void didChangeDependencies() { super.didChangeDependencies(); if (!initialized) { final size = MediaQuery.of(context).size; x = (size.width / 2) - ballRadius; y = (size.height / 2) - ballRadius; initialized = true; } }

  void startStep() {
    _timer?.cancel();
    setState(() { showInstruction = true; timeLeft = widget.routine.steps[stepIndex].duration; });
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() => showInstruction = false);
      _timer = Timer.periodic(const Duration(seconds: 1), (t) { if (!mounted) { t.cancel(); return; } setState(() { if (timeLeft > 0) { timeLeft--; } else { t.cancel(); nextStep(); } }); });
    });
  }

  void nextStep() { if (!mounted) return; if (stepIndex < widget.routine.steps.length - 1) { setState(() => stepIndex++); startStep(); } else { Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const CompletionScreen())); } }

  void moveBall() {
    if (!mounted || !bounceEnabled || showInstruction) return;
    final size = MediaQuery.of(context).size;
    setState(() { x += dx; y += dy; if (x <= 0 || x >= size.width - (ballRadius * 2)) dx = -dx; if (y <= 80 || y >= size.height - (ballRadius * 2) - 80) dy = -dy; });
  }

  Color timerColor() { final step = widget.routine.steps[stepIndex]; if (step.duration == 0) return Colors.green; double p = timeLeft / step.duration; if (p > 0.6) return Colors.green; if (p > 0.3) return Colors.yellow; return Colors.red; }

  @override
  Widget build(BuildContext context) {
    final step = widget.routine.steps[stepIndex];
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text(widget.routine.name), backgroundColor: widget.routine.color),
      body: Stack(
        children: [
          Positioned(top: 40, left: 20, right: 20, child: Text(step.title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white))),
          if (showInstruction && step.instructionImage.isNotEmpty)
            Center(
              child: Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(40)),
                child: Image.asset(step.instructionImage, width: 450, height: 450, fit: BoxFit.contain),
              ),
            ),
          if (!showInstruction)
            Positioned(
              left: bounceEnabled ? x : (size.width / 2) - ballRadius,
              top: bounceEnabled ? y : (size.height / 2) - ballRadius,
              child: GestureDetector(
                onTap: nextStep,
                child: Container(
                  width: ballRadius * 2, height: ballRadius * 2,
                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: timerColor(), width: 14)),
                  child: Container(
                    decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                    child: step.ballImage.isEmpty ? null : ClipOval(child: Image.asset(step.ballImage, fit: BoxFit.contain)),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() { _timer?.cancel(); controller.dispose(); super.dispose(); }
}