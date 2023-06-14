from PIL import Image
import sys
import os
import json


class CommandLineArgumentInformation:
    def __init__(self, name: str, description: str):
        self.name = name
        self.description = description


class CommandLineArgumentsInformation:
    arguments: list[CommandLineArgumentInformation] = []

    def __init__(self) -> None:
        self.add_argument("all", "If specified, write sprite.json file for all sprites in res/sprites directory")
        self.add_argument("overwrite", "If specified, overwrite sprite.json file for specified sprite(s)")
        self.add_argument("output", "Name of output file")
        self.add_argument("input", "File or directory where sprite is")
        self.add_argument("help", "Shows list of all available arguments")

    def add_argument(self, argument: str, description: str) -> None:
        self.arguments.append(CommandLineArgumentInformation(argument, description))

    def print(self):
        print("\nList of available arguments:\n")
        for argument in self.arguments:
            print(f"--{argument.name}, {argument.description}.\n")


class ComandLineArguments:
    arguments = {}

    def __init__(self) -> None:
        for arg in sys.argv:
            if (arg.startswith('--')):
                arr = arg[2:].split("=")
                name = arr[0]
                value = None
                if len(arr) == 2:
                    value = os.sep.join(arr[1].split("/"))
                self.arguments[name] = True if value == None else value

    
    def get(self, key: str) -> str | None:
        return self.arguments.get(key)


class FramePositions:
    def __init__(self):
        self.xFrom = 0
        self.xTo = 0
        self.yFrom = 0
        self.yTo = 0

    def build_sprite_info_frame(self):
        return SpriteInfoFrame(self.xFrom, self.yFrom, self.xTo - self.xFrom, self.yTo - self.yFrom)

    def reset(self):
        self.xFrom = 0
        self.xTo = 0
        self.yFrom = 0
        self.yTo = 0


class SpriteInfoFrame:
    def __init__(self, x: int, y: int, width: int, height: int):
        self.x = x
        self.y = y
        self.width = width
        self.height = height


class SpriteInfo:
    frames: list[SpriteInfoFrame]

    def __init__(self, name, speed = 15) -> None:
        self.name = name
        self.speed = speed
        self.frames = []

    
    def add_frame(self, frame: SpriteInfoFrame):
        self.frames.append(frame)


class SpriteInfoEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, SpriteInfo) or isinstance(obj, SpriteInfoFrame):
            return obj.__dict__
        return json.JSONEncoder.default(self, obj)


class ColumnInfo:
    def __init__(self, transparency: bool, firstY: int, lastY: int):
        self.transparency = transparency
        self.firstY = firstY
        self.lastY = lastY

    @staticmethod
    def get(image: Image.Image, index: int):
        transparency = True
        firstY = 0
        lastY = image.height - 1
        for y in range(image.height):
            if image.getpixel((index, y))[3] != 0:
                if firstY == 0:
                    firstY = y
                transparency = False
                lastY = y
        return ColumnInfo(transparency, firstY, lastY)
    

def write_sprite_info(input: str, output = "sprite.json", overwrite = False):
    output = output or "sprite.json"
    overwrite = overwrite or False

    input_path_parts = input.split(os.sep)
    output_path = os.path.join(os.sep.join(input_path_parts[:-1]), output)
    if os.path.exists(output_path) and not overwrite:
        raise Exception(f"{output_path} already exists, use --overwrite flag for overwrite")
    
    print(f"Write sprite info: {output_path}")

    image = Image.open(input)
    sprite_info = SpriteInfo(input_path_parts[-1])
    positions = FramePositions()
    is_last_column_transparency = False
    for x in range(image.width):
        column_info = ColumnInfo.get(image, x)
        if column_info.transparency:
            if not is_last_column_transparency:
                sprite_info.add_frame(positions.build_sprite_info_frame())
            is_last_column_transparency = True
            positions.reset()
            continue
        if is_last_column_transparency:
            positions.xFrom = x
            is_last_column_transparency = False
        positions.yFrom = min(positions.yFrom, column_info.firstY)
        positions.yTo = max(positions.yTo, column_info.lastY)
        positions.xTo = x
        if x == image.width - 1:
            sprite_info.add_frame(positions.build_sprite_info_frame())

    with open(output_path, 'w') as f:
        json.dump(sprite_info, f, cls=SpriteInfoEncoder)


def write_sprite_info_for_all_sprites(input: str, output: str, overwrite = False):
    for entry in os.listdir(os.path.join(input)):
        entry_path = os.path.join(input, entry)
        if os.path.isdir(entry_path):
            write_sprite_info_for_all_sprites(entry_path, output, overwrite)
        elif entry == 'sprite.png':
            write_sprite_info(entry_path, output, overwrite)


def main():
    # parse cli arguments
    arguments = ComandLineArguments()

    # shows list of commands and end execution
    if arguments.get("help"):
        CommandLineArgumentsInformation().print()
        return

    # get file path from argv or from --input argument
    file_path = arguments.get("input") if sys.argv[1].startswith("--") else sys.argv[1]
    if file_path.startswith("--") and os.path.isfile(file_path):
        write_sprite_info(file_path, arguments.get("output"), arguments.get("overwrite"))
    elif arguments.get("all") == True:
        write_sprite_info_for_all_sprites(arguments.get("input"), arguments.get("output"), arguments.get("overwrite"))
    else:
        raise Exception('Sprite path or --all argument not specified')

    
    


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("Bye")