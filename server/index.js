const express = require('express')
const fs = require('fs')
const path = require('path')
const cors = require('cors')
let app = express()


app.get("/catalog", (req,res) => {
  console.log("path reached")
  let catalog = getFile("Catalog")
  console.log(catalog)
  res.json(catalog)

})
// Music routes
app.get("/api/v1/featuredArtists", (req, res) => {
  console.log("route reached")
  let artists = getFile("FeaturedArtists")
  res.json(artists)
}) // get Featired Artists
app.get('/api/v1/featuredAlbums', (req,res) => {
  let albums = getFile("FeaturedAlbums")
  res.json(albums)
}) // Get Featured Albums
app.get('/api/v1/albums', (req,res) => {
  let keys = Object.keys(req.query)
  console.log(keys.toString())

  switch(keys.toString()){
    case "albumId":

    var albums = getFile("Albums")

    albums.map((album, id) => {
      if(album.Id == req.query.albumId){
        res.json(album)
      }
    })

    break;
    default:

    var albums = getFile("Albums")
    res.json(albums)

    // console.log(req.query)
  }
}) // Get Albums
app.get('/api/v1/trackhistory', (req,res) => {
  let history = getFile("songs")
  res.json(history)
}) // Get track history
app.get('/api/v1/playlists', (req,res) => {
  let playlists = getFile("Playlists")

  res.json(playlists)
}) // get all Playlists
app.get('/api/v1/tracks', (req,res) => {

let keys = Object.keys(req.query)
console.log("track route")
console.log(keys.toString())
switch(keys.toString()){
  case "trackId":
  console.log("Album",keys.toString())
    getFile('songs').map((track) => {
      if(track.Id == req.query.trackId){
          console.log("Track", track)
            res.json(track)
      }
    })
  break;

  default:
    let tracks = []

    getFile('songs').map((track, id) => {
      if(track.AlbumId == req.query.albumId){
            tracks.push(track)
      }
    })

    console.log(tracks)
    res.json(tracks)
  }
})
app.get('/api/v1/user', (req,res) => {
  console.log(req.query.user)
})

app.listen("3000", () => {
  console.log(`started app on 3000`)
})

function getFile(file){

  let data = fs.readFileSync(path.join(__dirname + "/" + file +".json"), (data, err) => {

    if( err ){
      console.log(err)
      return err
    }

    return data
  })
  return JSON.parse(data)
}
