# iShape

iShape is a compact and efficient library specifically designed for representing 2D data structures using FixVec.

## Data

- \`**FixPath**\` - A sequence of points defining a path.
- \`**FixPaths**\` - A list of paths.
- \`**FixShape**\` - A polygon that can include holes.
- \`**FixShapes**\` - A collection of shapes.

## Installation

Installing iShape is simple and easy using Swift Package Manager. Just follow these steps:

- Open your Xcode project.
- Select your project and open tab Package Dependencies.
- Click on the "+" button.
- In search bar enter ```https://github.com/iShape-Swift/iShape```
- Click the "Add" button.
- Wait for the package to be imported.
- In your Swift code, add the following using statement to access the library:

```swift
import iFixFloat
```

## Usage

Here's an example of how you can create a square with a hole using iShape:

```swift
// Square with a hole
let shape = FixShape(
    contour: [
        FixVec(-FixFloat.unit * 4, -FixFloat.unit * 4),
        FixVec(-FixFloat.unit * 4,  FixFloat.unit * 4),
        FixVec( FixFloat.unit * 4,  FixFloat.unit * 4),
        FixVec( FixFloat.unit * 4, -FixFloat.unit * 4)
    ], holes: [
        FixVec(-FixFloat.unit * 2, -FixFloat.unit * 2),
        FixVec(-FixFloat.unit * 2,  FixFloat.unit * 2),
        FixVec( FixFloat.unit * 2,  FixFloat.unit * 2),
        FixVec( FixFloat.unit * 2, -FixFloat.unit * 2)
    ]
)
```

## Contributing

Feel free to contribute to iShape by submitting issues, providing feedback, or making pull requests.

## Licenseå

This project is licensed under the MIT License. See the LICENSE file for more details.
