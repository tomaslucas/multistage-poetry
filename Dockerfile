# Dockerfile
# Uses multi-stage builds requiring Docker 17.05 or higher
# See https://docs.docker.com/develop/develop-images/multistage-build/

# Creating a python base with shared environment variables
FROM python:3.9-slim-buster AS python-base

ARG USERNAME=nonroot

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100 \
    POETRY_HOME="/opt/poetry" \
    POETRY_VIRTUALENVS_IN_PROJECT=true \
    POETRY_NO_INTERACTION=1 \
    PYSETUP_PATH="/opt/pysetup" \
    VENV_PATH="/opt/pysetup/.venv"

ENV PATH="$POETRY_HOME/bin:$VENV_PATH/bin:$PATH"

# builder-base is used to build dependencies
FROM python-base as builder-base

RUN apt update \
    && apt install --no-install-recommends -y \
    curl

# Install Poetry - respects $POETRY_VERSION & $POETRY_HOME
ENV POETRY_VERSION=1.1.2
RUN curl -sSL https://install.python-poetry.org | python3 -

# [Optional] Set the default user. Omit if you want to keep the default as root.
RUN adduser --disabled-password $USERNAME
USER $USERNAME

# We copy our Python requirements here to cache them
# and install only runtime deps using poetry
WORKDIR $PYSETUP_PATH
COPY --chown=$USERNAME:$USERNAME ./*poetry.lock ./pyproject.toml ./
RUN poetry install --no-dev  # respects 

# 'development' stage installs all dev deps and can be used to develop code.
# For example using docker-compose to mount local volume under /app
FROM python-base as development
ENV YOUR_ENV=development

RUN apt update \
    && apt install --no-install-recommends -y \
    curl \
    git

# [Optional] Set the default user. Omit if you want to keep the default as root.
RUN adduser --disabled-password $USERNAME
USER $USERNAME

# Copying poetry and venv into image
COPY --from=builder-base $POETRY_HOME $POETRY_HOME
COPY --from=builder-base $PYSETUP_PATH $PYSETUP_PATH

# venv already has runtime deps installed we get a quicker install
WORKDIR $PYSETUP_PATH
RUN poetry install

WORKDIR /app
COPY --chown=$USERNAME:$USERNAME . .

EXPOSE 8888
CMD ["/bin/bash"]

# 'test' stage runs our unit tests with pytest and
# coverage.  Build will fail if test coverage is under 95%
# FROM development AS test
# RUN coverage run --rcfile ./pyproject.toml -m pytest ./tests
# RUN coverage report --fail-under 95


# 'production' stage uses the clean 'python-base' stage and copyies
# in only our runtime deps that were installed in the 'builder-base'
FROM python-base as production
ENV YOUR_ENV=production

# [Optional] Set the default user. Omit if you want to keep the default as root.
RUN adduser --disabled-password $USERNAME
USER $USERNAME

COPY --from=builder-base $VENV_PATH $VENV_PATH

WORKDIR /app
COPY --chown=$USERNAME:$USERNAME ./src ./src
COPY --chown=$USERNAME:$USERNAME ./bin ./bin
COPY --chown=$USERNAME:$USERNAME *.py .

CMD [ "python", "bin/principal.py"]


