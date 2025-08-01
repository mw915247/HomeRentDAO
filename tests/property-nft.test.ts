import { describe, it, expect, beforeEach } from "vitest"

// Mock contract
const mockContract = {
  admin: "ST1ADMINHOSTADDRESS",
  verifiedHosts: new Map<string, boolean>(),
  nftOwners: new Map<number, string>(),
  nftMetadata: new Map<number, string>(),
  nextId: 1,

  isAdmin(caller: string) {
    return caller === this.admin
  },

  transferAdmin(caller: string, newAdmin: string) {
    if (!this.isAdmin(caller)) return { error: 100 }
    this.admin = newAdmin
    return { value: true }
  },

  addVerifiedHost(caller: string, host: string) {
    if (!this.isAdmin(caller)) return { error: 100 }
    if (this.verifiedHosts.has(host)) return { error: 104 }
    this.verifiedHosts.set(host, true)
    return { value: true }
  },

  mint(caller: string, metadata: string) {
    if (!this.verifiedHosts.has(caller)) return { error: 101 }
    const id = this.nextId
    this.nftOwners.set(id, caller)
    this.nftMetadata.set(id, metadata)
    this.nextId++
    return { value: id }
  },

  transfer(caller: string, tokenId: number, to: string) {
    const owner = this.nftOwners.get(tokenId)
    if (!owner) return { error: 103 }
    if (caller !== owner) return { error: 102 }
    this.nftOwners.set(tokenId, to)
    return { value: true }
  },
}

describe("Property NFT Contract", () => {
  beforeEach(() => {
    mockContract.admin = "ST1ADMINHOSTADDRESS"
    mockContract.verifiedHosts = new Map()
    mockContract.nftOwners = new Map()
    mockContract.nftMetadata = new Map()
    mockContract.nextId = 1
  })

  it("should add a verified host", () => {
    const result = mockContract.addVerifiedHost("ST1ADMINHOSTADDRESS", "ST2HOSTADDRESS")
    expect(result).toEqual({ value: true })
    expect(mockContract.verifiedHosts.has("ST2HOSTADDRESS")).toBe(true)
  })

  it("should mint NFT for verified host", () => {
    mockContract.addVerifiedHost("ST1ADMINHOSTADDRESS", "ST2HOSTADDRESS")
    const result = mockContract.mint("ST2HOSTADDRESS", "Cozy apartment")
    expect(result.value).toBe(1)
    expect(mockContract.nftOwners.get(1)).toBe("ST2HOSTADDRESS")
    expect(mockContract.nftMetadata.get(1)).toBe("Cozy apartment")
  })

  it("should transfer NFT to another user", () => {
    mockContract.addVerifiedHost("ST1ADMINHOSTADDRESS", "ST2HOSTADDRESS")
    const { value: id } = mockContract.mint("ST2HOSTADDRESS", "Nice villa")
    const transferResult = mockContract.transfer("ST2HOSTADDRESS", id, "ST3GUEST")
    expect(transferResult).toEqual({ value: true })
    expect(mockContract.nftOwners.get(id)).toBe("ST3GUEST")
  })

  it("should fail mint if caller is not verified host", () => {
    const result = mockContract.mint("ST3UNVERIFIED", "Unknown listing")
    expect(result).toEqual({ error: 101 })
  })
})
