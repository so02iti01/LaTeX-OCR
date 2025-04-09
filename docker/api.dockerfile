FROM python:3.8-slim

RUN apt-get update && apt-get install -y \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /latexocr

ADD pix2tex /latexocr/pix2tex/
ADD setup.py /latexocr/
ADD README.md /latexocr/

RUN pip install torch>=1.7.1

RUN pip install -v -e . && pip install -v fastapi uvicorn

RUN python -m pix2tex.model.checkpoints.get_latest_checkpoint

ENTRYPOINT ["uvicorn", "pix2tex.api.app:app", "--host", "0.0.0.0", "--port", "8502"]
