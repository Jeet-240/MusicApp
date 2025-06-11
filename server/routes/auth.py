import uuid
import bcrypt
from fastapi import Depends, HTTPException
from database import get_db
from models.user import User
from pydantic_schemas.user_create import UserCreate
from fastapi import APIRouter
from sqlalchemy.orm import Session

from pydantic_schemas.user_login import UserLogin

router = APIRouter()


@router.post('/signup' , status_code=201)
def signup_user(user: UserCreate , db: Session=Depends(get_db)):
    #this searched if user with same email ID already exists
    user_db = db.query(User).filter(User.email == user.email).first()

    if user_db:
        raise HTTPException(400, "User with the same email already exists")
   
    hashed_pw = bcrypt.hashpw(user.password.encode() , salt= bcrypt.gensalt())
    user_db = User(id = str(uuid.uuid4()), email = user.email, password = hashed_pw , name = user.name)
    db.add(user_db)
    db.commit() 
    db.refresh(user_db)

    return user_db       


@router.post('/login')
def login_user(user: UserLogin, db: Session = Depends(get_db)):
    #checks if a user with the input email already exists
    #if exists check password
    #if matches return user data else password error is thrown
    #if email does not match throw error


    user_db = db.query(User).filter(User.email == user.email).first()

    if not user_db:
        raise HTTPException(400, 'User with this email does not exists!')
    else:
        is_match = bcrypt.checkpw(user.password.encode() , user_db.password)
        if not is_match:
            raise HTTPException(400 , 'Incorrect Password')
        else:
            return user_db
  