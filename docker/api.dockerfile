FROM python:3.8-slim

# Install basic dependencies and Rust toolchain
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Install Rust and Cargo
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

WORKDIR /latexocr

# Add necessary files
ADD pix2tex /latexocr/pix2tex/
ADD setup.py /latexocr/
ADD README.md /latexocr/

# Install PyTorch
RUN pip install torch>=1.7.1

# Install the package with api extras
RUN pip install -e .[api]

# Download model
RUN python -m pix2tex.model.checkpoints.get_latest_checkpoint

ENTRYPOINT ["uvicorn", "pix2tex.api.app:app", "--host", "0.0.0.0", "--port", "8502"]
