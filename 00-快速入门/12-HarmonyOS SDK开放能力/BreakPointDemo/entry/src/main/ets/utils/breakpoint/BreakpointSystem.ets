declare interface BreakpointTypeOption<T> {
  //xs?: T,
  sm?: T,
  md?: T,
  lg?: T
}

export class BreakpointType<T> {
  option: BreakpointTypeOption<T>

  constructor(option: BreakpointTypeOption<T>) {
    this.option = option
  }

  getValue(currentBp: string): T {
    switch (currentBp) {
      case 'sm':
        return this.option.sm as T
      case 'md':
        return this.option.md as T
      default:
        return this.option.lg as T
    }
  }
}