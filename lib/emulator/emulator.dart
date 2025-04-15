import 'dart:async';
import 'dart:typed_data';

import './configuration.dart';
import './cpu/cpu.dart';
import './memory/cartridge.dart';

/// Represents the state of the emulator.
///
/// If data is not loaded the emulator is in WAITING state, after loading data is get into READY state.
///
/// When the game starts running it goes to RUNNING state, on pause it returns to READY.
enum EmulatorState { WAITING, READY, RUNNING }

/// Main emulator object used to directly interact with the system.
///
/// GUI communicates with this object, it is responsible for providing image, handling key input and user interaction.
class Emulator {
  /// State of the emulator, indicates if there is data loaded, and the emulation state.
  EmulatorState state = EmulatorState.WAITING;

  /// CPU object
  CPU? cpu = null;

  /// Press a gamepad button down (update memory register).
  void buttonDown(int button) {
    this.cpu?.buttons[button] = true;
  }

  /// Release a gamepad button (update memory register).
  void buttonUp(int button) {
    this.cpu?.buttons[button] = false;
  }

  /// Load a ROM from a file and create the HW components for the emulator.
  void loadROM(Uint8List data) {
    if (this.state != EmulatorState.WAITING) {
      print('Emulator should be reset to load ROM.');
      return;
    }

    Cartridge cartridge = Cartridge();
    cartridge.load(data);

    this.cpu = CPU(cartridge);
    this.state = EmulatorState.READY;

    this.printCartridgeInfo();
  }

  /// Print some information about the ROM file loaded into the emulator.
  void printCartridgeInfo() {
    print('Catridge info');
    if (cpu != null) {
      print('Type: ${cpu!.cartridge.type}');
      print('Name: ${cpu!.cartridge.name}');
      print('GB: ${cpu!.cartridge.gameboyType}');
      print('SGB: ${cpu!.cartridge.superGameboy}');
    }
  }

  /// Reset the emulator, stop running the code and unload the cartridge
  void reset() {
    this.cpu = null;
    this.state = EmulatorState.WAITING;
  }

  /// Do a single step in the cpu, set it to debug mode, step and then reset.
  void debugStep() {
    if (this.state != EmulatorState.READY) {
      print('Emulator not ready, cannot step.');
      return;
    }

    bool wasDebug = Configuration.debugInstructions;
    Configuration.debugInstructions = true;
    this.cpu?.step();
    Configuration.debugInstructions = wasDebug;
  }

  /// Run the emulation all full speed.
  void run() {
    if (this.state != EmulatorState.READY) {
      print('Emulator not ready, cannot run.');
      return;
    }

    this.state = EmulatorState.RUNNING;

    int frequency = CPU.FREQUENCY ~/ 4;
    double periodCPU = 1e6 / frequency;

    int fps = 30;
    double periodFPS = 1e6 / fps;

    int cycles = periodFPS ~/ periodCPU;
    Duration period = Duration(microseconds: periodFPS.toInt());

    Function loop = () async {
      while (true) {
        if (this.state != EmulatorState.RUNNING) {
          print('Stopped emulation.');
          return;
        }

        try {
          for (var i = 0; i < cycles; i++) {
            this.cpu?.step();
          }
        } catch (e, stacktrace) {
          print('Error occured, emulation stoped.');
          print(e.toString());
          print(stacktrace.toString());
          return;
        }

        await Future.delayed(period);
      }
    };

    loop();
  }

  /// Pause the emulation
  void pause() {
    if (this.state != EmulatorState.RUNNING) {
      print('Emulator not running cannot be paused');
      return;
    }

    this.state = EmulatorState.READY;
  }
}
