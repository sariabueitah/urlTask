# Short URL API

A simple Rails API for encoding and decoding URLs. This project uses SQLite as the database and provides RESTful endpoints for creating short URLs and retrieving the original URLs.

---

## Versions

- **Node.js:** 24.11.0
- **Ruby:** 3.4.8
- **Rails:** 8.1.1

---

## Installation

Follow these steps to get the project running locally:

1. **Clone the repository**

```bash
git clone <your-repo-url>
cd <your-repo-folder>
```

2. **Install Node.js dependencies**

```bash
npm install
```

3. **Install Ruby dependencies**

```bash
bundle install
```

4. **Setup the database**

The project uses SQLite and the database file is included in the `storage` folder. You do not need to install or configure SQLite separately. Just run:

```bash
rails db:setup
```

5. **Start the Rails server**

```bash
rails s
```

The server will run at: `http://localhost:3000`

---

## API Endpoints

### 1. Encode URL

**Request**

```bash
curl --location 'http://localhost:3000/api/v1/encode' \
--header 'Content-Type: application/json' \
--header 'Accept: application/json' \
--data '{
  "original_url": "https://example.com"
}'
```

**Response Example**

```json
{
  "success": true,
  "data": {
    "original_url": "https://example.com",
    "code": "AhDPBSF"
  }
}
```

---

### 2. Decode URL

**Request**

```bash
curl --location 'http://localhost:3000/api/v1/decode' \
--header 'Content-Type: application/json' \
--header 'Accept: application/json' \
--data '{
  "code": "AhDPBSF"
}'
```

**Response Example**

```json
{
  "success": true,
  "data": {
    "original_url": "https://example.com",
    "code": "AhDPBSF"
  }
}
```

---

## Notes

- Make sure your requests include the headers:

  - `Content-Type: application/json`
  - `Accept: application/json`

- Rate limiting is applied: a maximum of 10 encode requests every 3 minutes.
- SQLite database is pre-included in the `storage` folder; no additional configuration is required.
- Collision is resolved by checking if the code exists in the db and generating a new one in case it exists
- I save the codes and urls in the Database so a restart won't effect me if you don't want to save the data its possible by using base64 or some kind of compression
