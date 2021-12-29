# Bumpy Road

I feel like toying with a game engine and submitting to an Itch.io jam, namely [2021 Variety Megajam](https://itch.io/jam/variety-megajam-2021). I'm going to start with [Love2d's physics tutorial](https://love2d.org/wiki/Tutorial:Physics) code to get the feel for it and then try to make something from there.

My early thoughts are to have a ball roll down a procedurally-generated hill. I'm not sure how I'll turn that into a game, but hey I gotta start somewhere.

## Building

The Love2d game is in src/ . The rest of this repo is for building it and preparing to deploy to Itch.io . It relies on node and npm to install Love.js .

- Love2d, node, and npm need to be installed, and zip is needed to make the zip file
- `npm install` downloads Love.js
- `npm run-script build` creates the release/ folder and converts the Love2d project in src/ to html in release/
- `npm run-script zip` will delete any exisint bumpy-road.zip file and then create a new one with the contents of release/
- bumpy-road.zip can then be uploaded to Itch.io
- Caddyfile is to configure the caddy webserver which I am using locally. Just run `caddy` in the repo root folder, and the game will be available at http://localhost:2015 after release/ is populated by the build
