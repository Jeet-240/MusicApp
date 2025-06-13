import uuid
from fastapi import APIRouter, Depends, File, Form, UploadFile
from sqlalchemy.orm import Session
from database import get_db
from middleware import auth_middleware
import cloudinary
import cloudinary.uploader
from cloudinary.utils import cloudinary_url

from models.song import Song


router = APIRouter()



# Configuration       
config = cloudinary.config( 
    cloud_name = "dtukmutc6", 
    api_key = "992221869512323", 
    api_secret = "EcGDcnkmJvfOLsSk9rtoptvhvbE", # Click 'View API Keys' above to copy your API secret
    secure=True
)

@router.post('/upload' , status_code=201)
def upload_song(song: UploadFile = File(...), 
                thumbnail: UploadFile = File(...),
                  artist : str = Form(...), 
                  song_name : str = Form(...),
                  hex_code : str = Form(...),
                  db: Session = Depends(get_db),
                  auth_dict = Depends(auth_middleware.auth_middleware)
                  ):
    song_id = str(uuid.uuid4())
    song_res = cloudinary.uploader.upload(song.file, resource_type = 'auto' , folder=f'songs/{song_id}')  
    print(song_res['url']);
    thumbnail_res = cloudinary.uploader.upload(thumbnail.file, resource_type = 'image' , folder=f'songs/{song_id}')  
    print(thumbnail_res['url']);

    new_song = Song(
        id = song_id,
        song_name = song_name,
        artist = artist,
        hex_code = hex_code,
        song_url = song_res['url'],
        thumbnail_url = thumbnail_res['url']
    )

    db.add(new_song);
    db.commit()
    db.refresh(new_song)

    return new_song
    