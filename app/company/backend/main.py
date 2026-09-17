from fastapi import FastAPI, Request
from fastapi.templating import Jinja2Templates

app = FastAPI()

templates = Jinja2Templates(directory="templates")


@app.get("/api/company")
def company(request: Request):
    return templates.TemplateResponse(
        request=request,
        name="company.html",
        context={
            "company_name": "Megazone Bootcamp",
            "message": "FastAPI + Jinja 정상 동작"
        }
    )


@app.get("/api/health")
def health():
    return {"status": "ok"}