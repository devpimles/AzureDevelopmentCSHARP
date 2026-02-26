using Api.Data;
using Api.Domain;
using Microsoft.AspNetCore.Mvc;

namespace Api.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class NotesController : ControllerBase
    {
        private readonly ILogger<NotesController> _logger;
        private readonly NoteRepository _repo;

        public NotesController(
            ILogger<NotesController> logger,
            NoteRepository repo)
        {
            _logger = logger;
            _repo = repo;
        }

        // GET api/notes
        [HttpGet]
        public async Task<IActionResult> Get()
        {
            var notes = await _repo.GetAllAsync();
            return Ok(notes);
        }

        // GET api/notes/{id}
        [HttpGet("{id}")]
        public async Task<IActionResult> Get(string id)
        {
            var note = await _repo.GetByIdAsync(id);

            if (note == null)
                return NotFound();

            return Ok(note);
        }

        // POST api/notes
        [HttpPost]
        public async Task<IActionResult> Post([FromBody] CreateNoteRequest request)
        {
            if (string.IsNullOrWhiteSpace(request.Content))
                return BadRequest("Content is required.");

            var note = await _repo.CreateAsync(request.Content);

            return CreatedAtAction(
                nameof(Get),
                new { id = note.id },
                note);
        }

        // PUT api/notes/{id}
        [HttpPut("{id}")]
        public async Task<IActionResult> Put(string id, [FromBody] UpdateNoteRequest request)
        {
            var updated = await _repo.UpdateAsync(id, request.Content);

            if (!updated)
                return NotFound();

            return NoContent();
        }

        // DELETE api/notes/{id}
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(string id)
        {
            var deleted = await _repo.DeleteAsync(id);

            if (!deleted)
                return NotFound();

            return NoContent();
        }
    }
}