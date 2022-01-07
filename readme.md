# Ink and Love2d Visual Novel Test

I've never made a visual novel, and for reasons I don't want to take the easy/Ren'Py route.
I want to add a dialogue engine to another framework. In this first try I'll use a Lua port
of the Ink runtime to Love2d.

## Building

The Love2d game is in src/ . The rest of this repo is for building it and preparing to deploy to Itch.io . It relies on node and npm to install Love.js .

- Love2d, node, and npm need to be installed, and zip is needed to make the zip file
- `npm install` downloads Love.js
- `npm run-script build` creates the release/ folder and converts the Love2d project in src/ to html in release/
- `npm run-script zip` will delete any existing ink-love2d-vn-test.zip file and then create a new one with the contents of release/
- `npm run-script love` will delete any existing ink-love2d-vn-test.love file and then create a new one with the contents of src/
- ink-love2d-vn-test.zip can then be uploaded to Itch.io
- ink-love2d-vn-test.love can be played on any platform with Love2d installed
- Caddyfile is to configure the caddy webserver which I am using locally. Just run `caddy` in the repo root folder, and the game will be available at http://localhost:2015 after release/ is populated by the build

## Credits / Asset Licensing

### Parachute-icon.png

- Source: https://commons.wikimedia.org/wiki/File:Parachute-icon.png
- File URL: https://upload.wikimedia.org/wikipedia/commons/2/24/Parachute-icon.png
- MiniBjorn, CC BY-SA 3.0 <https://creativecommons.org/licenses/by-sa/3.0>, via Wikimedia Commons
- Image is displayed as rotated based on velocity

## SoccerBall.png

- Source: https://opengameart.org/content/soccer-ball
- Marked as public domain
