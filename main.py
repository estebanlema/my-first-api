from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session
from database import engine, Base, get_db
from models import Reminder
from schemas import ReminderCreate, ReminderResponse

Base.metadata.create_all(bind=engine)

app = FastAPI(title="Reminders API")

@app.get("/health")
def health():
    return {"status": "ok"}

@app.get("/")
def home():
    return {"message": "Reminders API is working!"}

@app.get("/reminders", response_model=list[ReminderResponse])
def get_reminders(db: Session = Depends(get_db)):
    return db.query(Reminder).all()

@app.get("/reminders/{reminder_id}", response_model=ReminderResponse)
def get_reminder(reminder_id: int, db: Session = Depends(get_db)):
    reminder = db.query(Reminder).filter(Reminder.id == reminder_id).first()
    if reminder is None:
        raise HTTPException(status_code=404, detail="Reminder not found")
    return reminder

@app.post("/reminders", response_model=ReminderResponse)
def create_reminder(reminder: ReminderCreate, db: Session = Depends(get_db)):
    new_reminder = Reminder(**reminder.dict())
    db.add(new_reminder)
    db.commit()
    db.refresh(new_reminder)
    return new_reminder

@app.put("/reminders/{reminder_id}", response_model=ReminderResponse)
def update_reminder(reminder_id: int, updated: ReminderCreate, db: Session = Depends(get_db)):
    reminder = db.query(Reminder).filter(Reminder.id == reminder_id).first()
    if reminder is None:
        raise HTTPException(status_code=404, detail="Reminder not found")
    for key, value in updated.dict().items():
        setattr(reminder, key, value)
    db.commit()
    db.refresh(reminder)
    return reminder

@app.delete("/reminders/{reminder_id}")
def delete_reminder(reminder_id: int, db: Session = Depends(get_db)):
    reminder = db.query(Reminder).filter(Reminder.id == reminder_id).first()
    if reminder is None:
        raise HTTPException(status_code=404, detail="Reminder not found")
    db.delete(reminder)
    db.commit()
    return {"message": f"Reminder {reminder_id} deleted successfully"}
