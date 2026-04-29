from pydantic import BaseModel
from datetime import datetime
from typing import Optional

class ReminderCreate(BaseModel):
    title: str
    due_date: Optional[datetime] = None
    completed: bool = False
    notes: Optional[str] = None
    priority: str = "medium"

class ReminderResponse(BaseModel):
    id: int
    title: str
    due_date: Optional[datetime]
    completed: bool
    notes: Optional[str]
    priority: str
    created_at: datetime

    model_config = {"from_attributes": True}
