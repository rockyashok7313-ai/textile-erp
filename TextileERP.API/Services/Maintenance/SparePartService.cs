using TextileERP.API.Models.Maintenance;
using TextileERP.API.Repositories.Maintenance;

namespace TextileERP.API.Services.Maintenance;

public class SparePartService : ISparePartService
{
    private readonly ISparePartRepository _repository;

    public SparePartService(ISparePartRepository repository)
    {
        _repository = repository;
    }

    public async Task<SparePart?> GetByIdAsync(long id) => await _repository.GetByIdAsync(id);

    public async Task<IEnumerable<SparePart>> GetAllAsync(long companyId)
    {
        return await _repository.FindAsync(s => s.CompanyId == companyId);
    }

    public async Task<IEnumerable<SparePart>> GetByCategoryAsync(string category, long companyId)
    {
        return await _repository.GetByCategoryAsync(category, companyId);
    }

    public async Task<IEnumerable<SparePart>> GetLowStockPartsAsync(long companyId)
    {
        return await _repository.GetLowStockPartsAsync(companyId);
    }

    public async Task<SparePart> CreateAsync(SparePart sparePart) => await _repository.AddAsync(sparePart);

    public async Task UpdateAsync(SparePart sparePart) => await _repository.UpdateAsync(sparePart);

    public async Task DeleteAsync(long id) => await _repository.DeleteAsync(id);

    public async Task<bool> IsCodeExistsAsync(string code, long? companyId, long? excludeId = null)
    {
        return await _repository.IsCodeExistsAsync(code, companyId, excludeId);
    }

    public async Task ConsumeStockAsync(long sparePartId, decimal quantity)
    {
        var sparePart = await _repository.GetByIdAsync(sparePartId);
        if (sparePart == null) throw new KeyNotFoundException("Spare part not found");
        if (sparePart.CurrentStock < quantity)
            throw new InvalidOperationException($"Insufficient stock. Available: {sparePart.CurrentStock}, Required: {quantity}");

        sparePart.CurrentStock -= quantity;
        await _repository.UpdateAsync(sparePart);
    }

    public async Task RestockAsync(long sparePartId, decimal quantity)
    {
        var sparePart = await _repository.GetByIdAsync(sparePartId);
        if (sparePart == null) throw new KeyNotFoundException("Spare part not found");

        sparePart.CurrentStock += quantity;
        await _repository.UpdateAsync(sparePart);
    }
}
