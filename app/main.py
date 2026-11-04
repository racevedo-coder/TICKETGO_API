from fastapi import FastAPI
from app.routes import reportes

app = FastAPI(title="TicketGo API")
app.include_router(reportes.router)