import '../cpu/cpu.dart';
import '../memory/memory_registers.dart';

/// Palette is used to store the gameboy palette colors.
///
/// Each palette is composed of four colors, for classic gameboy gray scale colors are stored.
///
/// For gameboy color the palette stores RGB colors.
abstract class Palette {
  late List<int> colors;

  /// Gets the RGBA color associated to a given index.
  int getColor(int number);
}

class GBPalette implements Palette {
  CPU cpu;
  int register = 0;
  List<int> colors;

  GBPalette(this.cpu, this.colors, this.register) {
    if (register != MemoryRegisters.BGP &&
        register != MemoryRegisters.OBP0 &&
        register != MemoryRegisters.OBP1) {
      throw Exception(
          "Register must be one of R.R_BGP, R.R_OBP0, or R.R_OBP1.");
    }

    if (colors.length < 4) {
      throw Exception("Colors must be of length 4.");
    }
  }

  @override
  int getColor(int number) {
    return this.colors[
        (this.cpu.mmu.readRegisterByte(this.register) >> (number * 2)) & 0x3];
  }
}

class GBCPalette implements Palette {
  List<int> colors;

  GBCPalette(this.colors) {
    if (colors.length < 4) {
      throw Exception("Colors must be of length 4.");
    }

    this.colors = colors;
  }

  @override
  int getColor(int number) {
    return this.colors[number];
  }
}
